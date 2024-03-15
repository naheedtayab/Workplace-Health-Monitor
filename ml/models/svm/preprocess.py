import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.decomposition import PCA
from scipy.fft import rfft

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
    "window_size": 20,
    "fft_components": 5,
    "pca_components": 0.95,  # Retain 95% of variance
    "scaling_method": "standard",  # or "minmax"
}


def load_data(file_path):
    """Load sensor data from a CSV file."""
    try:
        return pd.read_csv(file_path)
    except Exception as e:
        print(f"Error loading the data: {e}")
        raise


def generate_rolling_features(df, columns, window_size=20):
    """Generate rolling window features for each specified column."""
    for col in columns:
        df[f"{col}_rolling_mean"] = df[col].rolling(window=window_size).mean()
        df[f"{col}_rolling_std"] = df[col].rolling(window=window_size).std()
        df[f"{col}_rolling_min"] = df[col].rolling(window=window_size).min()
        df[f"{col}_rolling_max"] = df[col].rolling(window=window_size).max()
        df[f"{col}_diff"] = df[col].diff()  # First derivative
        df[f"{col}_diff2"] = df[col].diff().diff()  # Second derivative
    return df.dropna()  # Remove rows with NaN values


def scale_features(df, columns, method="standard"):
    """Scale features using specified method: 'standard' or 'minmax'."""
    if method == "standard":
        scaler = StandardScaler()
    elif method == "minmax":
        scaler = MinMaxScaler()
    else:
        raise ValueError("Unsupported scaling method")
    df[columns] = scaler.fit_transform(df[columns])
    return df


def apply_pca(df, n_components):
    """Apply PCA to reduce dimensionality while retaining a fraction of the variance."""
    pca = PCA(n_components=n_components)
    principalComponents = pca.fit_transform(df)
    return pd.DataFrame(principalComponents)


def preprocess_data(file_path):
    """Full preprocessing pipeline transforming raw CSV data into features ready for SVM."""
    df = load_data(file_path)
    df = generate_rolling_features(df, CONFIG["sensor_columns"], CONFIG["window_size"])

    # Generate frequency domain features from time series data
    # for col in CONFIG["sensor_columns"]:
    #     df = np.abs(rfft(df[col], n=CONFIG["fft_components"]))

    df = scale_features(df, CONFIG["sensor_columns"], CONFIG["scaling_method"])

    # Apply PCA for dimensionality reduction
    if CONFIG["pca_components"] > 0:
        df = apply_pca(df, CONFIG["pca_components"])

    return df
