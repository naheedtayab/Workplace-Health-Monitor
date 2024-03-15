import numpy as np
import random
from concurrent.futures import ProcessPoolExecutor


class DecisionTree:
    """
    A simple implementation of a decision tree for classification.

    Attributes:
        max_depth (int): The maximum depth of the tree.
        tree (dict): The nested dictionary storing the structure and decision nodes of the tree.
    """

    def __init__(self, max_depth=2):
        """
        Initializes a DecisionTree with a specified maximum depth.

        Args:
            max_depth (int): The maximum depth of the tree.
        """
        if not isinstance(max_depth, int) or max_depth < 1:
            raise ValueError("max_depth must be a positive integer")
        self.max_depth = max_depth
        self.tree = {}

    @staticmethod
    def gini_impurity(y):
        """
        Calculates the Gini impurity for an array of classes.

        Args:
            y (array-like): The list or array of class labels.

        Returns:
            float: The Gini impurity for the class distribution.
        """
        if len(y) == 0:  # Avoid division by zero
            return 0
        class_counts = np.bincount(y)
        probabilities = class_counts / np.sum(class_counts)
        impurity = 1 - np.sum(np.square(probabilities))
        return impurity

    @staticmethod
    def gini_gain(y, left_indices, right_indices):
        """
        Calculates the Gini gain from splitting the dataset into left and right nodes.

        Args:
            y (array-like): The list or array of class labels for the dataset.
            left_indices (list of int): The indices of samples that would be assigned to the left child.
            right_indices (list of int): The indices of samples that would be assigned to the right child.

        Returns:
            float: The Gini gain from the split.
        """
        left_impurity = DecisionTree.gini_impurity(y[left_indices])
        right_impurity = DecisionTree.gini_impurity(y[right_indices])
        left_weight = len(left_indices) / len(y)
        right_weight = len(right_indices) / len(y)
        return DecisionTree.gini_impurity(y) - (
            left_weight * left_impurity + right_weight * right_impurity
        )

    def find_best_split(self, X, y, feature_indices):
        """
        Finds the best feature and value to split the dataset on.

        Args:
            X (array-like): The feature matrix for the dataset.
            y (array-like): The list or array of class labels for the dataset.
            feature_indices (list of int): Indices of features to consider for splitting.

        Returns:
            tuple: The best feature index to split on, the value to split at, and the resulting split indices.
        """
        # Validate input
        if not feature_indices:
            raise ValueError("feature_indices must be non-empty")

        best_feature, best_value, best_gain, best_splits = None, None, 0, None
        for feature in feature_indices:
            values = set(X[:, feature])  # Unique values for this feature
            for value in values:
                left_indices = [i for i in range(len(X)) if X[i, feature] <= value]
                right_indices = [i for i in range(len(X)) if X[i, feature] > value]
                if not left_indices or not right_indices:
                    continue  # Skip this split if it doesn't divide the dataset

                gain = self.gini_gain(y, left_indices, right_indices)
                if gain > best_gain:
                    best_feature, best_value, best_gain = feature, value, gain
                    best_splits = (left_indices, right_indices)

        return best_feature, best_value, best_splits

    def build_tree(self, X, y, depth=0):
        """
        Recursively builds the decision tree.

        Args:
            X (array-like): The feature matrix for the dataset.
            y (array-like): The list or array of class labels for the dataset.
            depth (int): The current depth of the tree.

        Returns:
            dict: A nested dictionary representing the structure of the decision tree.
        """
        # Base cases
        if depth == self.max_depth or len(set(y)) == 1:
            return {"label": max(set(y), key=list(y).count)}

        feature_indices = random.sample(
            list(range(X.shape[1])), int(np.sqrt(X.shape[1]))
        )
        best_feature, best_value, best_splits = self.find_best_split(
            X, y, feature_indices
        )

        if best_feature is None:  # No effective split found
            return {"label": max(set(y), key=list(y).count)}

        left_X, left_y = X[best_splits[0]], y[best_splits[0]]
        right_X, right_y = X[best_splits[1]], y[best_splits[1]]

        # Recursively build the left and right branches
        left_branch = self.build_tree(left_X, left_y, depth + 1)
        right_branch = self.build_tree(right_X, right_y, depth + 1)

        return {
            "feature": best_feature,
            "value": best_value,
            "left": left_branch,
            "right": right_branch,
        }

    def fit(self, X, y):
        """
        Fits the decision tree model to the dataset.

        Args:
            X (array-like): The feature matrix for the dataset.
            y (array-like): The list or array of class labels for the dataset.
        """
        # Validate input sizes
        if X.shape[0] != len(y):
            raise ValueError("Mismatch between number of features and labels")
        self.tree = self.build_tree(X, y)

    def predict_one(self, node, x):
        """
        Predicts the class label for a single sample based on the decision tree.

        Args:
            node (dict): The current node in the decision tree.
            x (array-like): The feature vector for the sample.

        Returns:
            int: The predicted class label.
        """
        # Check if we're at a leaf node
        if "label" in node:
            return node["label"]
        # Otherwise move to the next node
        if x[node["feature"]] <= node["value"]:
            return self.predict_one(node["left"], x)
        else:
            return self.predict_one(node["right"], x)

    def predict(self, X):
        """
        Predicts class labels for a set of samples.

        Args:
            X (array-like): The matrix of features for the samples.

        Returns:
            list: The predicted class labels.
        """
        return [self.predict_one(self.tree, x) for x in X]


class SimpleRandomForest:
    """
    A simple implementation of a random forest classifier.

    Attributes:
        n_estimators (int): The number of trees in the forest.
        max_depth (int): The maximum depth of each tree in the forest.
        trees (list): A list of DecisionTree objects that make up the forest.
    """

    def __init__(self, n_estimators=10, max_depth=2):
        """
        Initializes a SimpleRandomForest with specified number of trees and maximum depth.

        Args:
            n_estimators (int): The number of trees in the forest.
            max_depth (int): The maximum depth of each tree in the forest.
        """
        # Validate parameters
        if not isinstance(n_estimators, int) or n_estimators < 1:
            raise ValueError("n_estimators must be a positive integer")
        if not isinstance(max_depth, int) or max_depth < 1:
            raise ValueError("max_depth must be a positive integer")
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.trees = []

    def bootstrap_sample(self, X, y):
        """
        Creates a bootstrap sample of the dataset.

        Args:
            X (array-like): The feature matrix for the dataset.
            y (array-like): The list or array of class labels for the dataset.

        Returns:
            tuple: Bootstrap sample of feature matrix and labels.
        """
        # Validate dataset integrity
        if X.shape[0] != len(y):
            raise ValueError("Mismatch between number of features and labels")
        n_samples = X.shape[0]
        indices = np.random.choice(n_samples, size=n_samples, replace=True)
        return X[indices], y[indices]

    def train_tree(self, sample_data):
        """
        Trains a single decision tree using a sample of the dataset.

        Args:
            sample_data (tuple): The bootstrap sample of feature matrix and labels.

        Returns:
            DecisionTree: The trained decision tree.
        """
        X_sample, y_sample = sample_data
        tree = DecisionTree(max_depth=self.max_depth)
        tree.fit(X_sample, y_sample)
        return tree

    def fit(self, X, y):
        """
        Trains the random forest on the dataset.

        Args:
            X (array-like): The feature matrix for the dataset.
            y (array-like): The list or array of class labels for the dataset.
        """
        # Generate bootstrap samples for each tree
        samples = [self.bootstrap_sample(X, y) for _ in range(self.n_estimators)]

        # Parallelize tree training using ProcessPoolExecutor
        with ProcessPoolExecutor() as executor:
            self.trees = list(executor.map(self.train_tree, samples))

    def predict(self, X):
        """
        Predicts class labels for a set of samples using the random forest.

        Args:
            X (array-like): The matrix of features for the samples.

        Returns:
            list: The predicted class labels, determined by majority vote among the trees.
        """
        if not self.trees:
            raise ValueError("The forest has not been trained yet")
        # Aggregate predictions from each tree
        tree_preds = np.array([tree.predict(X) for tree in self.trees])
        # Majority vote
        return np.round(tree_preds.mean(axis=0))
