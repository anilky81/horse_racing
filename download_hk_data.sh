#!/bin/bash
# Script to download Hong Kong racing data from eprochasson/horserace_data repository
# This is free, legal, and comprehensive historical data (1979-2018)

echo "=============================================="
echo "Hong Kong Racing Data Download Script"
echo "=============================================="
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

# Create data directory
DATA_DIR="./hong_kong_racing_data"
echo "Creating data directory: $DATA_DIR"
mkdir -p "$DATA_DIR"

# Clone the repository
echo ""
echo "Cloning horserace_data repository..."
echo "Source: https://github.com/eprochasson/horserace_data"
echo ""

cd "$DATA_DIR" || exit

if [ -d "horserace_data" ]; then
    echo "Repository already exists. Pulling latest changes..."
    cd horserace_data || exit
    git pull
else
    git clone https://github.com/eprochasson/horserace_data.git
    cd horserace_data || exit
fi

echo ""
echo "=============================================="
echo "Available Data Files:"
echo "=============================================="
ls -lh *.csv.gz 2>/dev/null || echo "No compressed CSV files found"

echo ""
echo "=============================================="
echo "Data Coverage:"
echo "=============================================="
echo "- Hong Kong: 1979 to 2018-06-27"
echo "- Singapore: 2002-03-08 to 2018-04-24"
echo ""
echo "Main datasets:"
echo "  1. horses.csv.gz        - All horses that ran races"
echo "  2. performances.csv.gz  - Individual race results (1979-2018)"
echo "  3. races.csv.gz         - Complete race information (2016-2018)"
echo "  4. all_dividends.csv.gz - Dividend results (2016-2018)"
echo "  5. sectional_times.csv.gz - Track positioning (2008-2018)"
echo "  6. live_odds.csv.gz     - Historical odds (2016-2018)"
echo ""

echo "=============================================="
echo "Next Steps:"
echo "=============================================="
echo "1. Extract data: gunzip *.csv.gz"
echo "2. Load into Python:"
echo "   import pandas as pd"
echo "   performances = pd.read_csv('performances.csv')"
echo "   races = pd.read_csv('races.csv')"
echo ""
echo "3. See HKJC_DATA_SOURCES.md for detailed mapping to match"
echo "   your existing Indian racing dataset format"
echo ""
echo "Data location: $(pwd)"
echo "=============================================="
