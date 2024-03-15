import tensorflow as tf
from tensorflow.python import keras
from keras.layers import Sequential, LSTM, Dense, Dropout
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout
from tensorflow.keras.optimizers import Adam


def build_lstm_model(input_shape, num_classes):
    """
    Builds an LSTM model according to the specified input shape and number of classes.

    Args:
        input_shape (tuple): Shape of the input sequences, e.g., (timesteps, features).
        num_classes (int): Number of distinct classes to predict.

    Returns:
        A compiled TensorFlow LSTM model.
    """
    model = Sequential(
        [
            # LSTM layer for extracting temporal features. Adjust units based on your dataset and complexity.
            LSTM(units=64, return_sequences=True, input_shape=input_shape),
            Dropout(0.5),  # Helps prevent overfitting
            LSTM(
                units=32
            ),  # Second LSTM layer. You can experiment with the number of units.
            Dropout(0.5),  # Helps prevent overfitting
            Dense(units=32, activation="relu"),  # Dense layer for prediction
            Dense(units=num_classes, activation="softmax"),  # Output layer
        ]
    )

    # Compile the model
    model.compile(
        optimizer=Adam(learning_rate=0.001),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )

    return model


# Example usage:
# Adjust 'timesteps' and 'features' based on your preprocessed data.
# Adjust 'num_classes' based on the total number of activities you are classifying.
# model = build_lstm_model(input_shape=(timesteps, features), num_classes=num_classes)
