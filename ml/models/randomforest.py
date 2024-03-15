from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import numpy as np

# Handle missing values (if any). For simplicity, we'll fill missing values with the median of each column.
sample_data_filled = sample_data.fillna(sample_data.median())

# Encode the 'Activity' labels into numeric form.
le = LabelEncoder()
sample_data_filled["Activity_encoded"] = le.fit_transform(
    sample_data_filled["Activity"]
)

# Now, let's create rolling window features for the sensor data.
# We'll use a window size of 10, which corresponds to 0.5 seconds of data at a 20Hz sampling rate.

window_size = 10  # You can adjust this based on your specific needs

# We'll calculate rolling means and standard deviations for sensor data.
feature_columns = [
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
    "Pedometer",
]
for col in feature_columns:
    sample_data_filled[f"{col}_mean"] = (
        sample_data_filled[col].rolling(window=window_size).mean()
    )
    sample_data_filled[f"{col}_std"] = (
        sample_data_filled[col].rolling(window=window_size).std()
    )

# Drop rows with NaN values resulting from rolling operation (mainly at the start of the dataset).
sample_data_clean = sample_data_filled.dropna()

# Split the dataset into features (X) and target label (y).
X = sample_data_clean.drop(["ID", "Activity", "Activity_encoded"], axis=1)
y = sample_data_clean["Activity_encoded"]

# Split the data into training and testing sets.
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42
)  # 70% training, 30% testing

# Initialize and train the Random Forest classifier.
rf_classifier = RandomForestClassifier(
    n_estimators=100, random_state=42
)  # You can tweak these parameters
rf_classifier.fit(X_train, y_train)

# Predict the activity type on the test set.
y_pred = rf_classifier.predict(X_test)

# Evaluate the model.
accuracy = accuracy_score(y_test, y_pred)
report = classification_report(y_test, y_pred, target_names=le.classes_)

(accuracy, report)
