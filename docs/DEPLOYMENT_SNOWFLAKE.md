# ☁️ Snowflake Deployment Guide

Deploy the AI Product Catalog entirely within Snowflake - no local setup required!

---

## 🎯 Why Deploy in Snowflake?

| Feature | Local Deployment | Snowflake Deployment |
|---------|------------------|---------------------|
| **Accessibility** | Only on your machine | Anywhere via URL |
| **Sharing** | Cannot share easily | Share URL with team |
| **Setup** | Python + packages | Just paste code |
| **Authentication** | Manual .env file | Automatic |
| **Maintenance** | Update local env | Update in UI |
| **Production Ready** | Dev/testing | Production use |

---

## 📋 Prerequisites

- ✅ Snowflake account (free trial: https://signup.snowflake.com/)
- ✅ ACCOUNTADMIN role access
- ✅ 15 minutes of time
- ✅ No Python installation needed!

---

## 🚀 Deployment Steps

### Step 1: Login to Snowflake

1. Go to https://app.snowflake.com
2. Login with your credentials
3. **Important**: Switch to **ACCOUNTADMIN** role
   - Click your username (top-right)
   - Select "Switch Role" → "ACCOUNTADMIN"

---

### Step 2: Run SQL Setup Scripts

#### 2.1 Open Worksheets

- Click **Worksheets** in left sidebar
- Click **+ Worksheet** to create new

#### 2.2 Execute Scripts in Order

Copy-paste and run each script from the `setup/` folder. **Run them in this exact order:**

**Script Execution Order:**

1. **01_initial_setup.sql** - Creates Database, Schema, Warehouse (10 seconds)
2. **02_data_ingestion.sql** - Creates RAW_PRODUCTS table with 15 products (5 seconds)
3. **03_ai_enrichment.sql** - Uses llama3.1-8b to enhance data (2-3 minutes) ⏱️
4. **04_semantic_search.sql** - Creates Vector embeddings with e5-base-v2 (30 seconds)
5. **05_rag_functions.sql** - Creates ASK_PRODUCT_CATALOG procedure (10 seconds)
6. **06_marketing_functions.sql** - Creates marketing automation procedures (10 seconds)
7. **07_analytics_views.sql** - Creates analytics views and insights (10 seconds)

**How to run:**
- Open SQL file from repository
- Copy entire contents
- Paste into Snowflake worksheet
- Click "Run All"
- Wait for completion

#### 2.3 Verify Setup ✅

After running all scripts, verify everything was created successfully.

**Expected Results:**
- Tables: 4-5
- Procedures: 5
- Views: 1

If numbers don't match, you missed a script!

---

### Step 3: Create Streamlit App

#### 3.1 Navigate to Streamlit

- Click **Streamlit** in left sidebar (under "Projects")
- If you don't see it, check your role is ACCOUNTADMIN

#### 3.2 Create New App

Click **+ Streamlit App** button

Fill in the form:
- **App name**: `Product_Catalog_AI`
- **Warehouse**: Select `CATALOG_WH`
- **App location**:
  - Database: `PRODUCT_CATALOG_AI`
  - Schema: `CATALOG`

Click **Create**

#### 3.3 Add Code

You'll see a code editor with default code.

**Delete all default code** (Ctrl+A, Delete)

**Open the file**: `streamlit_app/streamlit_snowflake.py` from the repository

**Copy entire contents** of that file

**Paste** into Snowflake Streamlit editor

#### 3.4 Run the App

Click **Run** button (top-right)

Wait 10-20 seconds for initialization

Your app is now live! 🎉

---

### Step 4: Access Your App

#### App URL Format:
```
https://app.snowflake.com/[account]/streamlit/Product_Catalog_AI
```

#### To Get Exact URL:

1. In Streamlit page, look at browser address bar
2. Or click **Share** button in app
3. Copy the URL

#### Share with Team:

Anyone with Snowflake access to your account can access the URL

**No additional authentication needed** - uses Snowflake login

---

## 🧪 Testing Your Deployment

### Test in Snowflake Worksheets

Open a worksheet and test the stored procedures:

**Test 1: Semantic Search**
```
CALL SEMANTIC_SEARCH('laptop for coding', 5);
```

**Test 2: Q&A System**
```
CALL ASK_PRODUCT_CATALOG('What is the cheapest product?');
```

**Test 3: Marketing Email**
```
CALL GENERATE_MARKETING_EMAIL(1);
```

**Test 4: Analytics**
```
SELECT * FROM CATEGORY_ANALYTICS;
CALL GENERATE_INSIGHTS();
```

### Test Streamlit App

Open your Streamlit URL and test all 5 pages:
- ✅ Home - View dashboard
- ✅ Semantic Search - Try searching "laptop"
- ✅ Ask Questions - Ask something
- ✅ Analytics - Generate insights
- ✅ Marketing Tools - Generate email

---

## 🔧 Troubleshooting

### Issue: "Model unavailable in your region"

**Error Message:**
```
Model llama3.1-8b unavailable in your region
```

**Solution:**
Enable cross-region inference. Run in a worksheet:
```
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';
```
Wait 2 minutes, then retry the failed script.

---

### Issue: "Insufficient privileges"

**Error Message:**
```
SQL access control error: Insufficient privileges to operate on schema 'CATALOG'
```

**Solution:**
Verify you're using ACCOUNTADMIN role. If not, switch roles and re-run the script.

---

### Issue: "Table does not exist"

**Error Message:**
```
Object 'CATEGORIZED_PRODUCTS' does not exist
```

**Solution:**
You skipped a SQL script. Scripts must run in order (01 → 07). Check which tables exist and re-run missing scripts.

---

### Issue: Streamlit app shows error

**Error:**
Connection error or blank screen

**Solution:**
- Check warehouse is running (may be suspended)
- Resume warehouse if needed
- Verify app has permissions
- Refresh Streamlit app (click "Rerun" in app)

---

### Issue: Streamlit not showing in sidebar

**Error:**
Can't find "Streamlit" option in sidebar

**Solution:**
- Ensure you're ACCOUNTADMIN role
- Check your Snowflake edition supports Streamlit
- Try refreshing the page
- Contact Snowflake support if issue persists

---

## 🔄 Updating Your Deployment

### Update Data

Add new products by inserting into RAW_PRODUCTS table, then re-run enrichment scripts (03-04)

### Update Streamlit App

1. Go to **Streamlit** in sidebar
2. Click on **Product_Catalog_AI**
3. Click **Edit** button
4. Modify code
5. Click **Run**

Changes are live immediately!

### Update SQL Functions

Re-run the SQL script with `CREATE OR REPLACE` to update existing procedures

---

## 💰 Cost Management

### Understanding Costs

| Component | Cost | Notes |
|-----------|------|-------|
| **Warehouse** | ~$2-4/hour | Only when running |
| **Storage** | Minimal | Sample data is small |
| **Cortex AI** | $0.50-2/day | Based on usage |

### Cost Optimization

**1. Auto-Suspend (Already Configured)**
- Warehouse auto-suspends after 60 seconds of inactivity

**2. Monitor Usage**
- Check warehouse usage in Snowflake console
- Review Cortex API calls in query history

**3. Suspend When Not Needed**
- Manually suspend warehouse when done testing
- Resume when needed

**4. Limit Cortex Usage**
- Use Cortex judiciously in production
- Cache frequent queries if possible

---

## 📊 Monitoring

### Check Warehouse Status

In Snowflake, go to Admin → Warehouses to see:
- Warehouse status (Running/Suspended)
- Credits used
- Query count

### Check Query History

View recent queries and their performance in:
- Activity → Query History

---

## 🔐 Security Best Practices

### User Access

Grant only necessary permissions:
- Read-only users: SELECT on tables/views
- Power users: EXECUTE on procedures
- Admins: Full access

### Data Privacy

- Sensitive data should be masked
- Use row-level security for multi-tenant
- Audit access regularly

---

## 🚀 Advanced Features

### Git Integration (Optional)

Connect your GitHub repo to Snowflake for automated deployments

### Scheduled Refresh

Set up tasks to refresh enriched data automatically

### Custom Domains

Use Snowflake's external access features for custom URLs

---

## 📚 Next Steps

After successful deployment:

1. ✅ Test all features thoroughly
2. ✅ Customize AI prompts for your use case
3. ✅ Add your own product data
4. ✅ Share app URL with stakeholders
5. ✅ Monitor costs and usage
6. ✅ Consider adding new features

---

## 📖 Additional Resources

- [Snowflake Cortex AI Documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions)
- [Streamlit in Snowflake Guide](https://docs.snowflake.com/en/developer-guide/streamlit/about-streamlit)
- [Git Integration in Snowflake](https://docs.snowflake.com/en/developer-guide/git/git-overview)
- [Cost Management Best Practices](https://docs.snowflake.com/en/user-guide/cost-understanding)

---

## 🆘 Getting Help

- Check [Troubleshooting](#-troubleshooting) section above
- Review Snowflake query history for errors
- Check warehouse status
- Verify all steps were completed

---

**🎉 Congratulations! Your AI Product Catalog is now live in Snowflake!**

[← Back to README](../README.md) | [Deploy Locally →](DEPLOYMENT_LOCAL.md)