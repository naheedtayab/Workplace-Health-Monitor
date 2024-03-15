import argparse
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score, StratifiedKFold
from sklearn.metrics import (
    classification_report,
    accuracy_score,
    f1_score,
    precision_score,
    recall_score,
)
from preprocess import preprocess_data
from model import SimpleRandomForest


def main():
    """
    Main function to handle the workflow of training, evaluating, and validating
    a Random Forest model on sensor data. This includes data preprocessing,
    model training, and evaluation using various metrics.
    """
    # Set up argument parsing for command line interaction
    parser = argparse.ArgumentParser(
        description="Train and evaluate a Random Forest model on sensor data."
    )
    parser.add_argument("data_path", type=str, help="Path to the sensor data CSV file")
    args = parser.parse_args()

    # Data preprocessing
    try:
        processed_df = preprocess_data(args.data_path)
    except Exception as e:
        print(f"Error during data preprocessing: {e}")
        return

    # Splitting dataset into features and target
    try:
        if "Activity" not in processed_df.columns:
            raise ValueError("Column 'Activity' not found in data.")
        X = processed_df.drop("Activity", axis=1)
        y = processed_df["Activity"]
    except Exception as e:
        print(f"Error splitting data into features and target: {e}")
        return

    # Data splitting for training and testing
    try:
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.3, random_state=42
        )
    except Exception as e:
        print(f"Error during data splitting: {e}")
        return

    # Initialize and train the Random Forest model
    try:
        rf = SimpleRandomForest(n_estimators=100, max_depth=10)
        # Cross-validation
        cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
        cv_scores = cross_val_score(rf, X_train, y_train, cv=cv, scoring="accuracy")
        print(f"Cross-validation scores: {cv_scores}")
        print(f"Mean cross-validation score: {cv_scores.mean()}")

        rf.fit(X_train, y_train)  # Training the model
    except Exception as e:
        print(f"Error during model training: {e}")
        return

    # Model evaluation
    try:
        predictions = rf.predict(X_test)
        # Various evaluation metrics
        accuracy = accuracy_score(y_test, predictions)
        precision = precision_score(y_test, predictions, average="macro")
        recall = recall_score(y_test, predictions, average="macro")
        f1 = f1_score(y_test, predictions, average="macro")
        print(f"Accuracy: {accuracy}")
        print(f"Precision: {precision}")
        print(f"Recall: {recall}")
        print(f"F1 Score: {f1}")
        print("Classification Report:\n", classification_report(y_test, predictions))
    except Exception as e:
        print(f"Error during model evaluation: {e}")
        return

    # Post-processing of predictions for debugging, not used in the actual app
    try:
        num_sedentary = np.sum(predictions == "sedentary")
        total_predictions = len(predictions)
        sedentary_ratio = num_sedentary / total_predictions

        print(f"Percentage of time sedentary: {sedentary_ratio * 100:.2f}%")

        # Set a threshold for when to alert the user
        sedentary_threshold = 0.5  # e.g., alert if sedentary more than 50% of the time
        if sedentary_ratio > sedentary_threshold:
            print("Alert: Consider increasing activity level.")

    except Exception as e:
        print(f"Error during post-processing: {e}")
        return


if __name__ == "__main__":
    main()
