import argparse
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score
from preprocess import preprocess_data

# Import the sklearn SVM model
from model import ActivitySVM as SklearnSVM

# Import the custom SVM model
from custom_svm import SVM as CustomSVM


def train_and_evaluate(model, X_train, X_test, y_train, y_test):
    """
    Train the model and evaluate its performance.
    """
    model.fit(X_train, y_train)
    predictions = model.predict(X_test)
    print(f"Accuracy: {accuracy_score(y_test, predictions)}")
    print(f"Classification Report:\n{classification_report(y_test, predictions)}")


def main():
    parser = argparse.ArgumentParser(
        description="Train and evaluate an SVM model on sensor data."
    )
    parser.add_argument("data_path", type=str, help="Path to the sensor data CSV file")
    parser.add_argument(
        "--use_custom", action="store_true", help="Use the custom SVM implementation"
    )
    args = parser.parse_args()

    # Data preprocessing
    processed_df = preprocess_data(args.data_path)

    # Splitting dataset into features and target
    X = processed_df.drop("Activity", axis=1).values
    y = processed_df["Activity"].values

    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.3, random_state=42
    )

    # Initialize and select the model
    if args.use_custom:
        print("Using custom SVM implementation.")
        model = CustomSVM()
    else:
        print("Using sklearn SVM implementation.")
        model = SklearnSVM()

    # Train and evaluate the model
    train_and_evaluate(model, X_train, X_test, y_train, y_test)


if __name__ == "__main__":
    main()
