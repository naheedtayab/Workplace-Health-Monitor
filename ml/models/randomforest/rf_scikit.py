import sys
import pandas as pd
import joblib
import coremltools
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

    # Save the trained Random Forest model to joblib file for CoreML conversion
    joblib_file = "random_forest_model.joblib"
    joblib.dump(rf_model, joblib_file)
    print(f"Model saved to {joblib_file}")

    # Convert the model to CoreML format
    coreml_model = coremltools.converters.sklearn.convert(
        rf_model,
        input_features=[
            "Acc_X",
            "Acc_Y",
            "Acc_Z",
            "Gyro_X",
            "Gyro_Y",
            "Gyro_Z",
            "Mag_X",
            "Mag_Y",
            "Mag_Z",
            "Barometer",
            "GPS_Lat",
            "GPS_Long",
            "Pedometer",
        ],
        output_feature_names=["Activity"],
    )
    coreml_model_file = "RandomForestModel.mlmodel"
    coreml_model.save(coreml_model_file)
    print(f"CoreML model saved to {coreml_model_file}")


if __name__ == "__main__":
    main()
