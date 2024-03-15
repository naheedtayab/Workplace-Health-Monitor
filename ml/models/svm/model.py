import numpy as np
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import GridSearchCV


class ActivitySVM:
    """
    A wrapper class for the Support Vector Machine model to classify physical activities.
    """

    def __init__(self, C=1.0, kernel="rbf", gamma="scale"):
        """
        Initializes the SVM model with specified hyperparameters.

        Args:
            C (float): Regularization parameter.
            kernel (str): Specifies the kernel type to be used in the algorithm.
            gamma (str or float): Kernel coefficient for 'rbf', 'poly' and 'sigmoid'.
        """
        self.model = SVC(C=C, kernel=kernel, gamma=gamma, probability=True)

    def train(self, X_train, y_train):
        """
        Trains the SVM model on the provided training data.

        Args:
            X_train (array-like): Training features.
            y_train (array-like): Training labels.
        """
        self.model.fit(X_train, y_train)

    def predict(self, X_test):
        """
        Performs prediction on the test data.

        Args:
            X_test (array-like): Test features.

        Returns:
            array: Predicted labels for the test data.
        """
        return self.model.predict(X_test)

    def evaluate(self, X_test, y_test):
        """
        Evaluates the performance of the model on the test data.

        Args:
            X_test (array-like): Test features.
            y_test (array-like): True labels for the test data.

        Returns:
            dict: A dictionary containing accuracy and classification report.
        """
        predictions = self.predict(X_test)
        accuracy = accuracy_score(y_test, predictions)
        report = classification_report(y_test, predictions)
        return {"accuracy": accuracy, "report": report}

    def optimize_parameters(self, X_train, y_train, param_grid, cv=5):
        """
        Performs hyperparameter tuning using GridSearchCV.

        Args:
            X_train (array-like): Training features.
            y_train (array-like): Training labels.
            param_grid (dict): Dictionary with parameters names as keys and lists of parameter settings to try as values.
            cv (int): Number of folds in cross-validation.

        Returns:
            best_params (dict): Parameter setting that gave the best results on the hold out data.
        """
        grid_search = GridSearchCV(self.model, param_grid, cv=cv)
        grid_search.fit(X_train, y_train)
        self.model = (
            grid_search.best_estimator_
        )  # Update the model with the best found parameters
        return grid_search.best_params_
