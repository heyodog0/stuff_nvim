# /// script
# requires-python = ">=3.11"
# dependencies = ["scikit-learn", "numpy"]
# ///
"""
A classic statistics walkthrough: simple linear regression.

We use scikit-learn's built-in `diabetes` dataset (no download needed) and the
single most predictive feature, BMI, to predict a measure of disease
progression one year later. One predictor means we can read the slope directly.

Run it with uv -- the `# /// script` block above tells uv which packages to
install on the fly, so this works with nothing pre-installed:

    uv run examples/regression.py
"""

import numpy as np
from sklearn.datasets import load_diabetes
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

# 1. Load the data. X is the feature matrix, y the target (disease progression).
data = load_diabetes()
bmi_index = list(data.feature_names).index("bmi")
X = data.data[:, [bmi_index]]   # keep 2-D shape (n_samples, 1) for sklearn
y = data.target

# Note: sklearn's diabetes features are standardized (mean 0), so "one unit of
# BMI" here means one standardized unit, not a raw BMI point.

# 2. Fit the model: y ≈ intercept + slope * bmi
model = LinearRegression().fit(X, y)
slope = model.coef_[0]
intercept = model.intercept_

# 3. Evaluate how much of the variation BMI explains.
predictions = model.predict(X)
r2 = r2_score(y, predictions)

# 4. Report and interpret.
print(f"Fitted line:  y = {intercept:.1f} + {slope:.1f} * bmi")
print(f"R²         :  {r2:.3f}")
print()
print("Interpretation:")
print(f"  • Each +1 standardized unit of BMI is associated with about")
print(f"    {slope:.0f} more units of disease progression.")
print(f"  • BMI alone explains {r2:.1%} of the variation in the outcome —")
print(f"    real, but far from the whole story (that's why models add features).")
