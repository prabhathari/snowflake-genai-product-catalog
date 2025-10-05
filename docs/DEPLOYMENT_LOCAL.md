# 🏠 Local Deployment Guide

Deploy and run the AI Product Catalog on your local machine.

---

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ **Snowflake Account** (free trial at https://signup.snowflake.com/)
- ✅ **Python 3.8 or higher** installed
- ✅ **pip** package manager
- ✅ **Git** installed
- ✅ **10-15 minutes** of time

---

## 🚀 Step-by-Step Setup

### Step 1: Clone Repository

Open your terminal and run:

```bash
git clone https://github.com/prabhathari/snowflake-genai-product-catalog.git
cd snowflake-genai-product-catalog
```

---

### Step 2: Snowflake Setup

#### 2.1 Login to Snowflake

1. Go to https://app.snowflake.com
2. Login with your credentials
3. Switch to **ACCOUNTADMIN** role (top-right dropdown)

#### 2.2 Run SQL Scripts in Order

Open **Worksheets** from left sidebar and run these scripts **one by one**:

**Order matters! Run in this sequence:**

1. `setup/01_initial_setup.sql` - Creates database, schema, and warehouse
2. `setup/02_data_ingestion.sql` - Inserts 15 sample products
3. `setup/03_ai_enrichment.sql` - Uses AI to clean and enhance data (takes 2-3 min)
4. `setup/04_semantic_search.sql` - Creates vector embeddings
5. `setup/05_rag_functions.sql` - Creates Q&A system
6. `setup/06_marketing_functions.sql` - Creates marketing automation
7. `setup/07_analytics_views.sql` - Creates analytics views

**How to run each script:**
- Open the SQL file from the `setup/` folder
- Copy entire contents
- Paste into Snowflake worksheet
- Click "Run All"
- Wait for completion before moving to next script

#### 2.3 Verify Snowflake Setup

After running all scripts, verify everything was created. You should see:
- Tables: 4-5 tables
- Procedures: 5 stored procedures
- Views: 1 view

---

### Step 3: Python Environment Setup

#### 3.1 Create Virtual Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On Mac/Linux:
source venv/bin/activate

# You should see (venv) in your terminal prompt
```

#### 3.2 Install Dependencies

```bash
# Upgrade pip
python -m pip install --upgrade pip

# Install all required packages
pip install -r requirements.txt

# Verify installation
pip list
```

**Required packages:**
- snowflake-connector-python
- snowflake-snowpark-python
- python-dotenv
- streamlit
- pandas

---

### Step 4: Configure Environment Variables

#### 4.1 Create .env File

```bash
# Copy the example file
cp .env.example .env

# On Windows (if cp doesn't work):
copy .env.example .env
```

#### 4.2 Edit .env File

Open `.env` in a text editor and fill in your Snowflake credentials:

```
SNOWFLAKE_ACCOUNT=abc12345.us-east-1.snowflakecomputing.com
SNOWFLAKE_USER=your_username
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_WAREHOUSE=CATALOG_WH
SNOWFLAKE_DATABASE=PRODUCT_CATALOG_AI
SNOWFLAKE_SCHEMA=CATALOG
```

**How to find your account identifier:**
- Login to Snowflake
- Look at the URL: `https://app.snowflake.com/ABC12345/...`
- Your account: `ABC12345.us-east-1.snowflakecomputing.com`

---

### Step 5: Test Connection

```bash
# Test Snowflake connection
python src/snowflake_connector.py
```

**Expected output:**
```
✅ Connected to Snowflake version: X.XX.X
✅ Session closed
```

**If you see errors:**
- Check .env file has correct credentials
- Verify virtual environment is activated
- Ensure Snowflake warehouse is running

---

### Step 6: Run Streamlit App

```bash
# Start the application
streamlit run streamlit_app/app.py
```

**Expected output:**
```
You can now view your Streamlit app in your browser.
Local URL: http://localhost:8501
Network URL: http://192.168.x.x:8501
```

The app will automatically open in your default browser at `http://localhost:8501`

---

## 🎨 Using the Application

### Home Page 🏠
- View total products, categories, average price
- Browse recent products table

### Semantic Search 🔍
- Enter natural language queries
- Example: "laptop for video editing"
- View similarity scores

### Ask Questions 💬
- Ask questions in plain English
- Example: "What's the best phone under $1000?"
- Get AI-generated answers

### Analytics 📊
- View category distribution charts
- See pricing analytics
- Generate AI business insights

### Marketing Tools 📝
- Generate product comparison tables
- Create marketing emails automatically

---

## 🧪 Testing

### Test Python Connection

```bash
python src/snowflake_connector.py
```

### Test Query Functions

```bash
python src/product_queries.py
```

---

## 🔧 Troubleshooting

### Issue: "ModuleNotFoundError: No module named 'src'"

**Solution:**
- Make sure you're in project root directory
- Activate virtual environment
- Run from project root: `streamlit run streamlit_app/app.py`

### Issue: "snowflake.connector.errors: Failed to connect"

**Solution:**
- Check `.env` file exists and has correct credentials
- Verify account URL format: `account.region.snowflakecomputing.com`
- Test connection: `python src/snowflake_connector.py`
- Ensure warehouse is running in Snowflake

### Issue: "Port 8501 already in use"

**Solution:**

```bash
# Kill existing Streamlit process
# Windows:
taskkill /F /IM streamlit.exe

# Mac/Linux:
pkill -f streamlit

# Or use different port:
streamlit run streamlit_app/app.py --server.port 8502
```

### Issue: "Table does not exist"

**Solution:**
- You skipped a SQL script
- Run all SQL scripts in order (01 → 07)
- Verify in Snowflake

### Issue: Python version error

**Solution:**
- Check Python version: `python --version`
- Must be 3.8 or higher
- If using multiple Python versions: use `python3`

---

## 🔄 Updating the Application

### Pull Latest Changes

```bash
git pull origin main
pip install -r requirements.txt
```

### Add New Products

Insert into RAW_PRODUCTS in Snowflake, then re-run enrichment scripts (03-04)

### Restart Application

Stop app (Ctrl+C in terminal), then start again

---

## 💡 Development Tips

### Hot Reload
Streamlit automatically reloads when you save changes to `app.py`

### Debug Mode
```bash
streamlit run streamlit_app/app.py --logger.level=debug
```

### Clear Cache
```bash
streamlit cache clear
```

### VS Code Setup
Add to `.vscode/settings.json`:
```json
{
    "python.defaultInterpreterPath": "./venv/Scripts/python.exe",
    "python.terminal.activateEnvironment": true
}
```

---

## 🛑 Stopping the Application

```bash
# In terminal where Streamlit is running
# Press: Ctrl+C

# Deactivate virtual environment
deactivate
```

---

## 📚 Next Steps

After successful local deployment:

1. ✅ Test all 5 pages in the Streamlit app
2. ✅ Add your own products to the catalog
3. ✅ Customize AI prompts in SQL scripts
4. ✅ Explore the code and learn how it works
5. ✅ Consider [deploying to Snowflake](DEPLOYMENT_SNOWFLAKE.md) for production

---

## 🆘 Getting Help

- Check [Troubleshooting](#-troubleshooting) section above
- Review error messages carefully
- Verify all prerequisites are met
- Check Snowflake query history for errors

---

**🎉 Success! Your local development environment is ready!**

[← Back to README](../README.md) | [Deploy to Snowflake →](DEPLOYMENT_SNOWFLAKE.md)