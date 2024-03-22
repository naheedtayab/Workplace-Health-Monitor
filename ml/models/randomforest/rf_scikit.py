import sys
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report


def main():
    if len(sys.argv) != 2:
        print("Usage: python train_random_forest.py <dataset.csv>")
        sys.exit(1)

    # Load the dataset
    dataset_path = sys.argv[1]
    df = pd.read_csv(dataset_path)

    # Prepare the data
    X = df.drop(["ID", "Activity"], axis=1)
    y = df["Activity"]

    # Split the data into training and test sets
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    # Initialize and train the Random Forest model
    rf_model = RandomForestClassifier(random_state=42)
    rf_model.fit(X_train, y_train)

    # Predict on the test set
    y_pred = rf_model.predict(X_test)

    # Evaluate the model
    accuracy = accuracy_score(y_test, y_pred)
    print(f"Accuracy: {accuracy}")
    print("Classification Report:\n", classification_report(y_test, y_pred))


if __name__ == "__main__":
    main()
