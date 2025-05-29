 # .github/workflows/ci.yml

name: Python CI for Snake Game

on:
  push:
    branches: [ "main", "develop" ] # Triggers on push to main or develop branch
  pull_request:
    branches: [ "main", "develop" ] # Triggers on pull requests targeting main or develop

jobs:
  build:
    runs-on: ubuntu-latest # Specifies the operating system for the job

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4 # Action to check out your repository code

      - name: Set up Python
        uses: actions/setup-python@v5 # Action to set up a Python environment
        with:
          python-version: '3.9' # Specify the Python version

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt # Installs pytest, flake8, mypy etc. from requirements.txt

      - name: Run Linting (Flake8)
        run: |
          flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics # Errors and common issues
          flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics # Style issues, exit-zero to allow tests to run even with style warnings

      - name: Run Type Checking (Mypy)
        run: |
          mypy . # Check for type consistency

      - name: Run Pytest Tests
        run: |
          pytest --cov=. --cov-report=xml # Run tests and generate coverage report (optional)
          # pytest # If you don't need coverage
