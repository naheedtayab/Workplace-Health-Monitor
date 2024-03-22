import numpy as np
import pandas as pd
import tensorflow as tf
from keras.layers import LSTM, Dense, Dropout, Sequential
from keras.optimizers import Adam
from keras.utils import to_categorical
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
import argparse
import joblib  # For saving preprocessing objects

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
    "window_size": 20,
    "step_size": 10,
    "test_size": 0.3,
}


# Preprocessing functions
def load_data(file_path):
    df = pd.read_csv(file_path)
    return df


# Scale features using StandardScaler
def scale_features(df, columns):
    scaler = StandardScaler()
    df[columns] = scaler.fit_transform(df[columns])
    return df, scaler


# Create sequences of sensor data
def create_sequences(df, window_size, step_size, columns):
    sequences = []
    labels = []
    for start in range(0, len(df) - window_size, step_size):
        end = start + window_size
        seq = df[columns][start:end].to_numpy()
        label = df["Activity"][end - 1]
        sequences.append(seq)
        labels.append(label)
    return np.array(sequences), np.array(labels)


# LSTM Model function
def build_lstm_model(input_shape, num_classes):
    model = Sequential(
        [
            LSTM(64, return_sequences=True, input_shape=input_shape),
            Dropout(0.5),
            LSTM(32),
            Dropout(0.5),
            Dense(32, activation="relu"),
            Dense(num_classes, activation="softmax"),
        ]
    )
    model.compile(
        optimizer=Adam(learning_rate=0.001),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )
    return model


def main(data_path):
    # Load and preprocess data
    df = load_data(data_path)
    df, scaler = scale_features(df, CONFIG["sensor_columns"])
    le = LabelEncoder()
    df["Activity"] = le.fit_transform(df["Activity"])
    sequences, labels = create_sequences(
        df, CONFIG["window_size"], CONFIG["step_size"], CONFIG["sensor_columns"]
    )
    X_train, X_test, y_train, y_test = train_test_split(
        sequences, labels, test_size=CONFIG["test_size"], random_state=42
    )

    # Convert labels to one-hot encoding
    num_classes = len(np.unique(y_train))
    y_train_oh = to_categorical(y_train, num_classes=num_classes)
    y_test_oh = to_categorical(y_test, num_classes=num_classes)

    # Build and train LSTM model
    input_shape = (CONFIG["window_size"], len(CONFIG["sensor_columns"]))
    model = build_lstm_model(input_shape, num_classes)
    model.fit(
        X_train,
        y_train_oh,
        epochs=20,
        batch_size=64,
        validation_data=(X_test, y_test_oh),
    )

    # Save the LSTM model and preprocessing objects
    model.save("lstm_activity_model.h5")
    joblib.dump(scaler, "scaler.joblib")
    joblib.dump(le, "label_encoder.joblib")

    print("Model and preprocessing objects have been saved.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Train an LSTM model for activity recognition."
    )
    parser.add_argument("data_path", type=str, help="Path to the sensor data CSV file")
    args = parser.parse_args()
    main(args.data_path)
