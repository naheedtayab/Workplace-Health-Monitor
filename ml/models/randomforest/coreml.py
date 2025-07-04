import coremltools
from sklearn.ensemble import RandomForestClassifier
import joblib

rf_model = joblib.load("random_forest_model.joblib")

# Convert the model
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

# Save the CoreML model
coreml_model.save("RandomForestActivityClassifier.mlmodel")
