#!/usr/bin/env python3
"""
Script to explore Hong Kong racing data and map it to the existing Indian racing dataset structure.

Usage:
    python explore_hk_data.py

Requirements:
    pip install pandas

Data Source: https://github.com/eprochasson/horserace_data
Coverage: Hong Kong racing 1979-2018
"""

import pandas as pd
import os
import sys
from pathlib import Path

def check_data_files(data_dir):
    """Check if required data files exist."""
    required_files = [
        'performances.csv',
        'races.csv',
        'horses.csv'
    ]

    missing_files = []
    for file in required_files:
        filepath = data_dir / file
        if not filepath.exists():
            # Check for compressed version
            compressed_filepath = data_dir / f"{file}.gz"
            if compressed_filepath.exists():
                print(f"Found compressed file: {compressed_filepath}")
                print(f"Please extract it: gunzip {compressed_filepath}")
                missing_files.append(file)
            else:
                missing_files.append(file)

    return missing_files

def load_hong_kong_data(data_dir):
    """Load Hong Kong racing data from CSV files."""
    print("\n" + "="*60)
    print("Loading Hong Kong Racing Data")
    print("="*60)

    try:
        # Load main datasets
        print("\n1. Loading performances data...")
        performances = pd.read_csv(data_dir / 'performances.csv')
        print(f"   - Loaded {len(performances):,} performance records")

        print("\n2. Loading races data...")
        races = pd.read_csv(data_dir / 'races.csv')
        print(f"   - Loaded {len(races):,} race records")

        print("\n3. Loading horses data...")
        horses = pd.read_csv(data_dir / 'horses.csv')
        print(f"   - Loaded {len(horses):,} horse records")

        return performances, races, horses

    except FileNotFoundError as e:
        print(f"\nError: {e}")
        print("\nPlease run ./download_hk_data.sh first to download the data")
        sys.exit(1)

def explore_data_structure(performances, races, horses):
    """Explore the structure of Hong Kong racing data."""
    print("\n" + "="*60)
    print("Data Structure Analysis")
    print("="*60)

    print("\n--- PERFORMANCES DATA (Individual horse results) ---")
    print(f"Columns: {list(performances.columns)}")
    print(f"\nFirst few rows:")
    print(performances.head())
    print(f"\nData types:")
    print(performances.dtypes)
    print(f"\nDate range:")
    if 'date' in performances.columns:
        print(f"From: {performances['date'].min()}")
        print(f"To: {performances['date'].max()}")

    print("\n--- RACES DATA (Race-level information) ---")
    print(f"Columns: {list(races.columns)}")
    print(f"\nFirst few rows:")
    print(races.head())
    print(f"\nData types:")
    print(races.dtypes)

    print("\n--- HORSES DATA (Horse information) ---")
    print(f"Columns: {list(horses.columns)}")
    print(f"\nFirst few rows:")
    print(horses.head())

def map_to_indian_format(performances, races, horses):
    """
    Map Hong Kong data to match Indian racing dataset format.

    Indian format columns (from HorRacingHistory.csv):
    V1: Position
    V2: Weight
    V3: Unknown (-)
    V4: Horse Number
    V5: Status (A/S)
    V6: Distance Behind
    V7: Position in Race
    V8: Unknown
    V9: Unknown
    V10: Time
    V11: Distance
    V12: Race Name
    V13: Horse Link/ID
    V14: Jockey
    V15: Trainer
    V16: Venue/Date
    """
    print("\n" + "="*60)
    print("Mapping to Indian Dataset Format")
    print("="*60)

    # Merge performances with races to get complete information
    print("\nMerging performances with race information...")

    # Check available columns for merging
    perf_cols = set(performances.columns)
    race_cols = set(races.columns)

    print(f"\nPerformances columns: {perf_cols}")
    print(f"\nRaces columns: {race_cols}")

    # Common merge keys to try
    possible_merge_keys = ['race_id', 'id', 'race_key']
    merge_key = None

    for key in possible_merge_keys:
        if key in perf_cols and key in race_cols:
            merge_key = key
            break

    if merge_key:
        print(f"\nMerging on: {merge_key}")
        merged_data = performances.merge(races, on=merge_key, how='left', suffixes=('_perf', '_race'))
        print(f"Merged data shape: {merged_data.shape}")
        print(f"\nMerged columns: {list(merged_data.columns)}")

        # Display sample of merged data
        print(f"\nSample merged data:")
        print(merged_data.head())

        # Create mapping
        print("\n" + "-"*60)
        print("Column Mapping Guide:")
        print("-"*60)

        mapping = {
            'Position (V1)': 'result / finish_position / place',
            'Weight (V2)': 'declared_weight / actual_weight',
            'Horse Number (V4)': 'horse_no / number',
            'Distance Behind (V6)': 'behind / lengths_behind',
            'Time (V10)': 'finish_time / time',
            'Distance (V11)': 'distance (from races table)',
            'Race Name (V12)': 'race_name / name (from races table)',
            'Horse ID (V13)': 'horse_id',
            'Jockey (V14)': 'jockey_id / jockey',
            'Trainer (V15)': 'trainer_id / trainer',
            'Venue/Date (V16)': 'venue + date (from races table)'
        }

        for indian_col, hk_col in mapping.items():
            print(f"{indian_col:20} -> {hk_col}")

        return merged_data
    else:
        print("\nWarning: Could not find common merge key between performances and races")
        print("Available columns will need manual mapping")
        return performances

def generate_sample_output(merged_data):
    """Generate a sample CSV in Indian format."""
    print("\n" + "="*60)
    print("Generating Sample Output")
    print("="*60)

    # Select columns that match Indian format (if available)
    # This is a template - actual columns will depend on the data structure
    output_columns = {}

    # Try to map columns (adjust based on actual column names)
    possible_mappings = {
        'V1': ['result', 'finish_position', 'place', 'position'],
        'V2': ['declared_weight', 'actual_weight', 'weight'],
        'V4': ['horse_no', 'number', 'draw'],
        'V6': ['behind', 'lengths_behind', 'distance_behind'],
        'V10': ['finish_time', 'time', 'final_time'],
        'V11': ['distance'],
        'V12': ['race_name', 'name'],
        'V13': ['horse_id'],
        'V14': ['jockey_id', 'jockey'],
        'V15': ['trainer_id', 'trainer'],
        'V16': ['venue', 'date']
    }

    sample_df = pd.DataFrame()

    for indian_col, possible_cols in possible_mappings.items():
        for col in possible_cols:
            if col in merged_data.columns:
                sample_df[indian_col] = merged_data[col]
                print(f"Mapped {indian_col} <- {col}")
                break

    if len(sample_df.columns) > 0:
        output_file = 'hong_kong_racing_sample.csv'
        sample_df.head(100).to_csv(output_file)
        print(f"\nSample data saved to: {output_file}")
        print(f"\nSample preview:")
        print(sample_df.head(10))
    else:
        print("\nCould not automatically map columns.")
        print("Please review the data structure and create mapping manually.")

    return sample_df

def main():
    """Main execution function."""
    print("\n" + "="*60)
    print("Hong Kong Racing Data Explorer")
    print("="*60)
    print("\nThis script helps you explore and map Hong Kong racing data")
    print("to match your existing Indian racing dataset format.")

    # Locate data directory
    data_dir = Path('./hong_kong_racing_data/horserace_data')

    if not data_dir.exists():
        print(f"\nData directory not found: {data_dir}")
        print("\nPlease run ./download_hk_data.sh first to download the data")
        print("Or update the data_dir variable in this script to point to your data location")
        sys.exit(1)

    print(f"\nData directory: {data_dir}")

    # Check for required files
    missing_files = check_data_files(data_dir)
    if missing_files:
        print(f"\nMissing required files: {missing_files}")
        print("\nPlease extract compressed files:")
        print(f"  cd {data_dir}")
        print(f"  gunzip *.csv.gz")
        sys.exit(1)

    # Load data
    performances, races, horses = load_hong_kong_data(data_dir)

    # Explore structure
    explore_data_structure(performances, races, horses)

    # Map to Indian format
    merged_data = map_to_indian_format(performances, races, horses)

    # Generate sample output
    if merged_data is not None:
        generate_sample_output(merged_data)

    print("\n" + "="*60)
    print("Exploration Complete")
    print("="*60)
    print("\nNext Steps:")
    print("1. Review the column mappings above")
    print("2. Adjust the mapping in this script as needed")
    print("3. Process the full dataset to create your Hong Kong racing dataset")
    print("4. See HKJC_DATA_SOURCES.md for more information")
    print("="*60 + "\n")

if __name__ == "__main__":
    main()
