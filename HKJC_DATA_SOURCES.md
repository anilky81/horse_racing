# Hong Kong Horse Racing Data Sources

## Executive Summary

This document outlines available sources for Hong Kong Jockey Club (HKJC) racing data for creating a dataset similar to the Indian racing data currently in this repository. The HKJC website (racing.hkjc.com) has bot protection (403 errors), but several alternative sources exist with historical data dating back to 1979.

---

## Current Dataset Structure (Indian Racing)

The existing dataset includes:
- **Race Results**: Position, horse weight, jockey, trainer, time, distance, race name
- **Venue/Session Data**: Location (Bangalore, Kolkata), dates, racing sessions
- **Format**: CSV files with 15+ columns per race result

**Key Fields**: Position, Weight, Draw, Distance, Time, Race Name, Horse ID, Jockey, Trainer, Venue, Date

---

## Available Hong Kong Racing Data Sources

### 1. GitHub Repository: eprochasson/horserace_data ⭐ RECOMMENDED
**URL**: https://github.com/eprochasson/horserace_data

**Coverage**:
- Hong Kong: 1979 to 2018-06-27
- Comprehensive historical dataset

**Six Main Datasets**:
1. **horses** - List of all horses that ran races (up to 2018-07-01)
2. **performances** - Individual race results (1979-2018)
3. **races** - Complete race information (2016-09-28 to 2018-06-27)
4. **all_dividends** - JSON-encoded dividend results (2016-2018)
5. **sectional_times** - Track positioning data (2008-06-05 to 2018-06-27)
6. **live_odds** - Historical odds tracking (2016-2018)

**Format**: Compressed CSV files, easily loadable to databases, pandas, or Excel

**Pros**:
- Free and open source
- Comprehensive historical coverage (1979-2018)
- Well-structured CSV format
- Ready to use

**Cons**:
- Data only up to 2018 (not updated recently)
- Some fields occasionally empty

---

### 2. HorseRaceDatabase.com ⭐ MOST COMPREHENSIVE
**URL**: https://horseracedatabase.com

**Coverage**:
- Historical: 1979 to present season
- Updated: Daily race results and racecards

**Service Options**:

#### Historical Dataset (One-time purchase)
- **Coverage**: 1979 - current season
- **Price**: €79.90 first month, then €19.90/month
- **Includes**: Race results, horses, races, trainers, jockeys, racecard stats, dividends, veterinary records

#### Daily Updated Service (Subscription)
- **Updates**: Every race day
- **Price**: Monthly subscription (€19.90/month after first month)
- **Includes**: Latest racecards, race results, full runner details, sectional timings, odds, dividends, veterinary updates

**Formats**: CSV, JSON, SQL inserts, MySQL dumps, PostgreSQL dumps

**API**: Coming soon (subscribers get exclusive pre-sale discounts)

**Pros**:
- Most comprehensive (1979-present)
- Multiple export formats
- Daily updates available
- Professional data quality
- Future API access

**Cons**:
- Paid service (not free)
- Subscription required for updates

---

### 3. GitHub Repository: j-csc/HK-Horse-Racing-Data-Scraper
**URL**: https://github.com/j-csc/HK-Horse-Racing-Data-Scraper

**Description**: Python-based web scraper for HKJC website

**Data Collected**:
- Horse veterinary records
- Penetrometer readings
- Horse information (comprehensive)
- Horse roarer designations
- Racecard details
- Racecard-specific information

**How to Use**:
1. Clone repository
2. Install Python dependencies from requirements.txt
3. Run main.py script

**Pros**:
- Free and open source
- Can collect latest data directly from HKJC
- Customizable scraping

**Cons**:
- Requires Python knowledge
- No legal/ToS guidance provided
- HKJC website has bot protection
- May break if HKJC changes website structure
- Legal gray area for scraping

---

### 4. Kaggle Datasets

Multiple Hong Kong racing datasets available on Kaggle:

#### Dataset 1: Horse Racing Dataset for Experts (Hong Kong)
- **URL**: https://www.kaggle.com/datasets/hrosebaby/horse-racing-dataset-for-experts-hong-kong
- **Status**: Access restricted (403 error during exploration)

#### Dataset 2: Hong Kong Horse Racing Results 2014-17 Seasons
- **URL**: https://www.kaggle.com/lantanacamara/hong-kong-horse-racing
- **Coverage**: 2014-2017 seasons

#### Dataset 3: Hong Kong Horse Racing Data
- **URL**: https://www.kaggle.com/datasets/gdaley/hkracing

**Pros**:
- Free access
- Ready-to-use format
- Community support

**Cons**:
- Limited time periods
- Not regularly updated
- Variable data quality

---

### 5. GitHub Repository: acmayuen/HK-Horse-Racing
**URL**: https://github.com/acmayuen/HK-Horse-Racing

**Contents**:
- Database 2008-2009.xlsx (historical dataset)
- data desc.xlsx (data structure documentation)
- HorseraceExample.R (sample R script)
- hrdata2008-2016.R (main data processing script)
- test.Rmd (R Markdown analysis examples)

**Data Scale**: ~8,000 races, ~100,000 rows (2008-2016)

**Pros**:
- Includes data documentation
- Example R scripts for analysis
- Feature engineering examples

**Cons**:
- Requires R knowledge
- Limited time period (2008-2016)
- Data not recently updated

---

## Hong Kong Racing Data Structure

### Typical CSV Dataset Columns

Based on analysis of multiple sources, Hong Kong racing datasets typically include:

#### Race-Level Information (races.csv):
- **date** - Race date
- **race_no** - Race number
- **venue** - Sha Tin or Happy Valley
- **going** - Track condition
- **surface** - Track surface type
- **prize** - Prize money
- **distance** - Race distance
- **class** - Race class/grade
- **sectional_times** - Various timing fields

#### Horse/Runner-Level Information (runs.csv):
- **race_id** - Race identifier
- **horse_id** - Horse identifier
- **horse_no** - Horse number in race
- **horse_name** - Name of horse
- **horse_age** - Age of horse
- **horse_sex** - Gender
- **horse_country** - Origin country
- **horse_rating** - Official rating
- **result** / **finish_position** - Final placing
- **finish_time** - Total time (seconds)
- **horse_gear** - Equipment worn
- **draw** - Starting gate position
- **declared_weight** - Combined weight
- **actual_weight** - Applied weight
- **win_odds** - Win betting odds
- **place_odds** - Place betting odds
- **trainer_id** / **trainer** - Trainer identifier
- **jockey_id** / **jockey** - Jockey identifier
- **behind** - Distance behind leader
- **position** - Running positions during race

#### Additional Data (when available):
- **Veterinary records** - Horse health information
- **Trackwork** - Training session data
- **Dividends** - Payout information
- **Pool odds** - Betting pool data
- **Sectional times** - Split times during race

---

## Legal and Ethical Considerations

### Web Scraping Legality

**Key Points**:
1. **HKJC Terms**: Terms prohibit making modifications, derivative works, or redistribution of their platform content
2. **Hong Kong Privacy Laws**: 2024-2025 increased enforcement on data scraping and privacy protection
3. **Best Practices**:
   - Check robots.txt (visit https://racing.hkjc.com/robots.txt)
   - Review website Terms of Service
   - Consider rate limiting and respectful scraping
4. **Personal Use**: Generally more acceptable than commercial use, but doesn't automatically make it legal

### Recommendations:
1. ✅ **Use existing open datasets** (GitHub repositories, Kaggle) - SAFEST
2. ✅ **Use commercial services** (HorseRaceDatabase.com) - LEGAL
3. ⚠️ **Scraping for personal use** - GRAY AREA (check ToS first)
4. ❌ **Commercial scraping without permission** - RISKY

### Data Usage Ethics:
- ✅ Data analysis and research
- ✅ Personal projects and learning
- ⚠️ Publishing derived datasets (cite sources)
- ❌ Commercial use without permission
- ❌ Claiming scraped data as your own

---

## Recommended Approach for Creating Hong Kong Dataset

### Option 1: Quick Start (Free) ⭐ RECOMMENDED FOR LEARNING
1. **Use eprochasson/horserace_data GitHub repository**
   - Clone: `git clone https://github.com/eprochasson/horserace_data.git`
   - Extract compressed CSV files
   - Load into pandas/database
   - Coverage: 1979-2018 (comprehensive historical data)

2. **Supplement with Kaggle datasets** for more recent data (2014-2017)

**Pros**: Free, legal, immediate access, comprehensive
**Cons**: Data only up to 2018

### Option 2: Professional/Commercial (Paid) ⭐ RECOMMENDED FOR PRODUCTION
1. **Subscribe to HorseRaceDatabase.com**
   - Purchase historical dataset (1979-present)
   - Subscribe to daily updates
   - Multiple format options (CSV, JSON, SQL)
   - Future API access

**Pros**: Most complete, up-to-date, legal, professional quality
**Cons**: Costs €19.90/month after first month

### Option 3: DIY Scraping (Advanced) ⚠️ USE WITH CAUTION
1. **Review HKJC's robots.txt and Terms of Service**
   - Visit: https://racing.hkjc.com/robots.txt
   - Read: https://member.hkjc.com/member/general/en-US/terms-and-conditions.html
2. **Use j-csc/HK-Horse-Racing-Data-Scraper** if permitted
3. **Implement rate limiting** and respectful scraping practices
4. **For personal use only**

**Pros**: Latest data, customizable, free
**Cons**: Legal uncertainty, requires technical skills, may break, bot protection (403 errors)

---

## Implementation Steps (Recommended Approach)

### For Quick Start with Free Data:

```bash
# 1. Clone the repository
git clone https://github.com/eprochasson/horserace_data.git
cd horserace_data

# 2. List available data files
ls -lh *.csv.gz

# 3. Extract data (example)
gunzip performances.csv.gz
gunzip races.csv.gz
gunzip horses.csv.gz

# 4. Load into Python/Pandas
# python
# import pandas as pd
# performances = pd.read_csv('performances.csv')
# races = pd.read_csv('races.csv')
# horses = pd.read_csv('horses.csv')
```

### Data Structure Mapping:

To match your existing Indian racing dataset structure, map Hong Kong data as follows:

| Indian Dataset Column | Hong Kong Dataset Column | Source File |
|-----------------------|-------------------------|-------------|
| Position | result / finish_position | performances.csv |
| Weight | declared_weight / actual_weight | performances.csv |
| Draw | draw | performances.csv |
| Distance | distance | races.csv |
| Time | finish_time | performances.csv |
| Race Name | race_name | races.csv |
| Horse ID | horse_id | performances.csv |
| Jockey | jockey_id | performances.csv |
| Trainer | trainer_id | performances.csv |
| Venue | venue (Sha Tin/Happy Valley) | races.csv |
| Date | date | races.csv |

---

## Additional Resources

### Community Forums:
- **Data Science Hong Kong**: https://discourse.datasciencehongkong.com/t/hong-kong-jockey-club-hkjc-horse-racing-data-for-free/16

### Analysis Examples:
- Medium: https://medium.com/@kahoikwok/data-analysis-project-hong-kong-horse-racing-prediction-part-i-e63103155658
- GitHub Projects: Multiple repositories with analysis examples

### Official HKJC Resources:
- **Racing Results**: https://racing.hkjc.com/racing/information/English/Racing/LocalResults.aspx
- **Statistics**: https://racing.hkjc.com/racing/information/English/racing/Draw.aspx
- **Veterinary Records**: https://racing.hkjc.com/racing/information/English/VeterinaryRecords/OVERoar.aspx

---

## Conclusion

**Best Path Forward**:

1. **Start with eprochasson/horserace_data** (free, comprehensive, 1979-2018)
2. **Structure your dataset** to match your existing Indian racing format
3. **For current data**, either:
   - Subscribe to HorseRaceDatabase.com (professional, legal)
   - Use Kaggle datasets for 2014-2017 period
   - Carefully scrape HKJC if legally permitted and for personal use only

4. **Document your data sources** and respect licensing terms

This approach provides a solid foundation for Hong Kong racing analysis while respecting legal and ethical boundaries.

---

**Last Updated**: 2025-11-07
**Data Sources Verified**: Multiple GitHub repositories, Kaggle, HorseRaceDatabase.com, HKJC website
