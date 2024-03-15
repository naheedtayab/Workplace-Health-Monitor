import numpy as np
import pandas as pd
import argparse
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split

# Configuration parameters
CONFIG = {
    "sensor_columns": [
        "Acc_X",
        "Acc_Y",
        "Acc_Z",
        "Gyro_X",
        "Gyro_Y",
        "Gyro_Z",
        "Mag_X",
        "Mag_Y",
        "Mag_Z",
    ],
    "window_size": 20,  # Number of time steps in each sequence
    "step_size": 10,  # Steps to move ahead in each iteration (for overlap)
    "test_size": 0.3,  # Test set size
}


def load_data(file_path):
    """Load sensor data from a CSV file."""
    try:
        df = pd.read_csv(file_path)
        return df
    except Exception as e:
        print(f"Error loading the data: {e}")
        raise


def scale_features(df, columns):
    """Scale features using standard scaling."""
    scaler = StandardScaler()
    df[columns] = scaler.fit_transform(df[columns])
    return df


def create_sequences(df, window_size, step_size, columns):
    """
    Create sequences from the time series data.
    """
    sequences = []
    labels = []
    for start in range(0, len(df) - window_size, step_size):
        end = start + window_size
        seq = df[columns][start:end].to_numpy()
        # Use the label (activity) of the last row in the window
        label = df["Activity"][end - 1]
        sequences.append(seq)
        labels.append(label)
    return np.array(sequences), np.array(labels)


def preprocess_data_for_lstm(file_path):
    """
    Full preprocessing pipeline transforming raw CSV data into sequences ready for LSTM.
    """
    df = load_data(file_path)
    df = scale_features(df, CONFIG["sensor_columns"])

    # Convert labels to integers
    le = LabelEncoder()
    df["Activity"] = le.fit_transform(df["Activity"])

    sequences, labels = create_sequences(
        df, CONFIG["window_size"], CONFIG["step_size"], CONFIG["sensor_columns"]
    )

    # Split the sequences and labels into training and testing datasets
    X_train, X_test, y_train, y_test = train_test_split(
        sequences, labels, test_size=CONFIG["test_size"], random_state=42
    )

    return X_train, X_test, y_train, y_test, le.classes_


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Preprocess sensor data for LSTM model training."
    )
    parser.add_argument("data_path", type=str, help="Path to the sensor data CSV file")
    args = parser.parse_args()

    # Preprocess the data
    X_train, X_test, y_train, y_test, class_names = preprocess_data_for_lstm(
        args.data_path
    )

    # Add code here if you want to save or further manipulate the processed data
    print("Preprocessing complete. Data ready for LSTM model.")
