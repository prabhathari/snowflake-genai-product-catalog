# 🤖 AI-Powered Product Catalog with Snowflake Cortex

A production-ready product catalog system powered by Snowflake Cortex AI, featuring semantic search, RAG-based Q&A, and automated marketing content generation.

![Snowflake](https://img.shields.io/badge/Snowflake-Cortex_AI-blue)
![Python](https://img.shields.io/badge/Python-3.8+-green)
![Streamlit](https://img.shields.io/badge/Streamlit-1.50-red)

---

## 🌟 Features

- **🤖 AI-Powered Data Enrichment** - Automatically clean and enhance product descriptions using LLMs
- **🔍 Semantic Search** - Find products using natural language with vector embeddings
- **💬 RAG Q&A System** - Ask questions about your catalog in plain English
- **📊 Auto-Categorization** - ML-based product classification
- **📝 Marketing Automation** - Generate product comparisons and marketing emails
- **📈 AI Analytics** - Get business insights automatically
- **🎨 Interactive Dashboard** - Beautiful Streamlit UI with 5 pages

---

## 🏗️ Architecture

```
Raw Data → AI Enrichment → Vector Embeddings → RAG System → Dashboard
```

### Technology Stack

| Component | Technology |
|-----------|-----------|
| **Database** | Snowflake Cloud Data Platform |
| **AI Models** | Snowflake Cortex (llama3.1-8b, e5-base-v2) |
| **Backend** | Python, Snowpark |
| **Frontend** | Streamlit |
| **Vector Search** | Snowflake Vector Functions |

---

## 🎯 What This Does

### The Problem
- Messy product data: "laptop dell xps 13", "gud laptop fast performance"
- Hard to find products with keyword search
- Manual marketing content creation takes hours

### The Solution
- **AI cleans data**: "Dell XPS 13 Laptop" with professional descriptions
- **Semantic search**: Find "video editing laptop" even if product doesn't say those words
- **Auto-generate**: Marketing emails, product comparisons, business insights
- **Ask questions**: "What's the best phone under $1000?" → AI answers instantly

---

## 🚀 Quick Start

### Choose Your Deployment Method

| Method | Best For | Time | Difficulty |
|--------|----------|------|------------|
| **[Deploy in Snowflake](docs/DEPLOYMENT_SNOWFLAKE.md)** | Production, sharing with team | 15 mins | Easy |
| **[Deploy Locally](docs/DEPLOYMENT_LOCAL.md)** | Development, testing | 20 mins | Medium |

### Prerequisites

- Snowflake account (free trial: https://signup.snowflake.com/)
- Python 3.8+ (for local deployment only)

---

## 📊 Sample Use Cases

### 1. E-Commerce Product Search
- User searches: "laptop for video editing"
- AI finds: MacBook Pro, Dell XPS 15 (based on specs, not keywords)

### 2. Customer Support Automation
- Customer asks: "Do you have waterproof cameras?"
- AI answers: "Yes, the GoPro Hero 12 Black is waterproof..."

### 3. Marketing Content Generation
- Select product → Click "Generate Email"
- AI creates: Subject line, engaging copy, call-to-action
- Time saved: 30 minutes per email

### 4. Business Intelligence
- Click "Generate Insights"
- AI analyzes: Category performance, pricing trends, recommendations

---

## 🎓 Skills Demonstrated

### Technical Skills
✅ Cloud Data Warehousing (Snowflake)  
✅ Generative AI & Large Language Models  
✅ Vector Embeddings & Semantic Search  
✅ RAG (Retrieval Augmented Generation)  
✅ SQL (Advanced - procedures, CTEs, dynamic SQL)  
✅ Python Programming  
✅ Data Pipeline Development  
✅ Full-Stack Development  

### Business Value
✅ Automated data enrichment (saves hours)  
✅ Improved search experience (higher conversions)  
✅ Reduced support workload (AI Q&A)  
✅ Marketing automation (faster content creation)  
✅ Data-driven insights (better decisions)  

---

## 📁 Project Structure

```
snowflake-genai-product-catalog/
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
├── docs/
│   ├── DEPLOYMENT_LOCAL.md
│   └── DEPLOYMENT_SNOWFLAKE.md
├── setup/
│   ├── 01_initial_setup.sql
│   ├── 02_data_ingestion.sql
│   ├── 03_ai_enrichment.sql
│   ├── 04_semantic_search.sql
│   ├── 05_rag_functions.sql
│   ├── 06_marketing_functions.sql
│   └── 07_analytics_views.sql
├── src/
│   ├── snowflake_connector.py
│   └── product_queries.py
└── streamlit_app/
    ├── app.py
    └── streamlit_snowflake.py
```

---

## 🔑 Key Technologies Explained

### Snowflake Cortex AI
Built-in AI functions in Snowflake - no external APIs needed. Use SQL functions to call LLMs directly.

### Semantic Search
Converts text to vectors (arrays of numbers) that understand meaning. Finds similar products by comparing vector similarity.

### RAG (Retrieval Augmented Generation)
1. User asks question
2. Find relevant products using vector search
3. Send products + question to LLM
4. LLM generates accurate answer based on YOUR data

---

## 📈 Performance & Costs

### Snowflake Trial
- ✅ Free for 30 days
- ✅ $400 in free credits
- ✅ All features included

### Production Costs (Estimated)
- **Warehouse**: ~$10-20/month (X-SMALL, auto-suspend enabled)
- **Cortex AI**: ~$0.50-2/day (light usage)
- **Storage**: Minimal for sample data

### Optimization Tips
- Keep warehouse at X-SMALL size
- Enable auto-suspend (60 seconds)
- Use Cortex judiciously for production

---

## 🛠️ Extending This Project

### Add New Products
Insert into RAW_PRODUCTS table, then re-run enrichment scripts 03-04

### Add New Features
- Multi-language translation
- Product recommendations
- Image analysis (Cortex Vision)
- Bulk CSV upload
- REST API endpoints

### Customize AI Prompts
Edit the prompts in scripts 03, 05, 06 to match your industry, tone, and output format

---

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

---

## 📝 License

MIT License - Free to use for learning and portfolio projects

---

## 👤 Author

**Your Name**  
📧 Email: prabhat.hari@gmail.com  
🔗 LinkedIn: [your-linkedin](www.linkedin.com/in/prabhat-yenisetti-7366b41b)  
💼 GitHub: [@prabhathari](https://github.com/prabhathari)

---

## 🙏 Acknowledgments

- **Snowflake** for Cortex AI platform
- **Meta AI** for Llama models
- **Streamlit** for the dashboard framework
- **Open Source Community** for inspiration

---

## 📚 Resources

- [Snowflake Cortex AI Documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions)
- [Streamlit in Snowflake](https://docs.snowflake.com/en/developer-guide/streamlit/about-streamlit)
- [RAG Architecture Explained](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/rag)
- [Vector Search Guide](https://docs.snowflake.com/en/user-guide/vector-search)

---

## ⭐ Star This Repo

If you found this project helpful, please give it a star! It helps others discover it.

---

**Built with ❤️ using Snowflake Cortex AI**