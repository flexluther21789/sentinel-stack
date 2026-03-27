import pandas as pd
from sklearn.ensemble import IsolationForest
import joblib
import os
import sys

path = os.path.expanduser('~/sentinel-stack/data/syscall_telemetry.csv')

if not os.path.exists(path) or os.path.getsize(path) == 0:
    print("Error: syscall_telemetry.csv is missing or empty. Capture data first.")
    sys.exit(1)

try:
    # Read the data, treating any amount of whitespace as a delimiter
    df = pd.read_csv(path, sep='\s+', header=None, on_bad_lines='skip')
    
    # Isolation Forest needs numbers. We drop the timestamp and non-numeric columns.
    X = df.apply(pd.to_numeric, errors='coerce').dropna(axis=1, how='all').fillna(0)
    
    model = IsolationForest(contamination=0.01, random_state=42)
    model.fit(X)
    
    joblib.dump(model, os.path.expanduser('~/sentinel-stack/sentinel_model.pkl'))
    print("✓ Sentinel Model Trained Successfully.")
except Exception as e:
    print(f"Python Error: {e}")
