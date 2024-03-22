import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from scipy.fft import rfft
from sklearn.feature_selection import VarianceThreshold

# Configuration parameters for preprocessing
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
    "window_size": 20,  # Size of the rolling window for feature generation
    "fft_components": 5,  # Number of components to keep from FFT
    "variance_threshold": 0.01,  # Threshold for feature selection via Variance Threshold
}


def load_data(file_path):
    """
    Load sensor data from a CSV file.

    Args:
        file_path (str): Path to the CSV file containing the sensor data.

    Returns:
        pd.DataFrame: DataFrame containing the loaded data.

    Raises:
        Exception: If the CSV file cannot be loaded.
    """
    try:
        return pd.read_csv(file_path)
    except Exception as e:
        print(f"Error loading the data: {e}")
        raise


def generate_rolling_features(df, columns, window_size=20):
    """
    Generate rolling window features for each specified column.

    Args:
        df (pd.DataFrame): DataFrame containing the sensor data.
        columns (list of str): List of column names to calculate rolling features for.
        window_size (int): The number of observations used for calculating the rolling statistics.

    Returns:
        pd.DataFrame: The original DataFrame with added rolling window features.
    """
    for col in columns:
        df[f"{col}_rolling_mean"] = df[col].rolling(window=window_size).mean()
        df[f"{col}_rolling_std"] = df[col].rolling(window=window_size).std()
        df[f"{col}_rolling_min"] = df[col].rolling(window=window_size).min()
        df[f"{col}_rolling_max"] = df[col].rolling(window=window_size).max()
        # Derivative features capture the rate of change in sensor readings
        df[f"{col}_diff"] = df[col].diff()
        df[f"{col}_diff2"] = df[col].diff().diff()
    # Remove initial rows with NaN values resulting from the rolling and differencing operations
    return df.dropna()


def standardize_features(df, columns):
    """
    Standardize sensor features by removing the mean and scaling to unit variance.

    Args:
        df (pd.DataFrame): DataFrame containing the sensor data.
        columns (list of str): List of column names to be standardized.

    Returns:
        pd.DataFrame: DataFrame with standardized feature columns.
    """
    scaler = StandardScaler()
    df[columns] = scaler.fit_transform(df[columns])
    return df


def generate_frequency_features(df, columns, n_components=5):
    """
    Generate frequency domain features using the Fast Fourier Transform (FFT).

    Args:
        df (pd.DataFrame): DataFrame containing the sensor data.
        columns (list of str): List of column names to transform into the frequency domain.
        n_components (int): Number of frequency components to retain.

    Returns:
        pd.DataFrame: DataFrame with added frequency domain features.
    """
    for col in columns:
        fft_values = rfft(df[col])
        for i in range(n_components):
            df[f"{col}_fft_{i}"] = np.abs(fft_values[:, i])
    return df


def select_features(df, threshold=0.01):
    """
    Remove features with low variance.

    Args:
        df (pd.DataFrame): DataFrame containing the sensor data.
        threshold (float): Features with a variance lower than this threshold will be removed.

    Returns:
        pd.DataFrame: DataFrame with only high-variance features.
    """
    selector = VarianceThreshold(threshold=threshold)
    return pd.DataFrame(
        selector.fit_transform(df), columns=df.columns[selector.get_support()]
    )


def preprocess_data(file_path):
    """
    Preprocess sensor data: load, standardize, generate features, and select relevant features.

    Args:
        file_path (str): Path to the CSV file containing the sensor data.

    Returns:
        pd.DataFrame: Preprocessed sensor data ready for machine learning models.
    """
    df = load_data(file_path)

    # Apply preprocessing steps
    df = standardize_features(df, CONFIG["sensor_columns"])
    df = generate_rolling_features(df, CONFIG["sensor_columns"], CONFIG["window_size"])
    df = generate_frequency_features(
        df, CONFIG["sensor_columns"], CONFIG["fft_components"]
    )
    df = select_features(df, CONFIG["variance_threshold"])

    return df


# processed_data = preprocess_data('path_to_your_data.csv')
