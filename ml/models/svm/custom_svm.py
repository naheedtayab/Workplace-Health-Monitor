import numpy as np


class SVM:
    """
    Simple implementation of a linear Support Vector Machine (SVM).
    """

    def __init__(self, learning_rate=0.001, lambda_param=0.01, n_iters=1000):
        """
        Initializes the SVM with specified learning rate, regularization parameter, and number of iterations.

        Args:
            learning_rate (float): The learning rate for the gradient descent optimization.
            lambda_param (float): The regularization parameter.
            n_iters (int): The number of iterations to run the gradient descent optimization.
        """
        self.learning_rate = learning_rate
        self.lambda_param = lambda_param
        self.n_iters = n_iters
        self.w = None
        self.b = None

    def fit(self, X, y):
        """
        Fits the SVM model to the training data.

        Args:
            X (np.array): The feature matrix for the training data.
            y (np.array): The target vector for the training data, should be -1 or 1.
        """
        n_samples, n_features = X.shape
        y_ = np.where(y <= 0, -1, 1)  # Convert binary labels to -1 and 1

        self.w = np.zeros(n_features)
        self.b = 0

        # Gradient descent for optimization
        for _ in range(self.n_iters):
            for idx, x_i in enumerate(X):
                condition = y_[idx] * (np.dot(x_i, self.w) - self.b) >= 1
                if condition:
                    self.w -= self.learning_rate * (2 * self.lambda_param * self.w)
                else:
                    self.w -= self.learning_rate * (
                        2 * self.lambda_param * self.w - np.dot(x_i, y_[idx])
                    )
                    self.b -= self.learning_rate * y_[idx]

    def predict(self, X):
        """
        Makes predictions using the trained SVM model.

        Args:
            X (np.array): The feature matrix for the data to make predictions on.

        Returns:
            np.array: The predicted classes.
        """
        approx = np.dot(X, self.w) - self.b
        return np.sign(approx)
