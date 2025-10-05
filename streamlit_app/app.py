import streamlit as st
import pandas as pd
# import sys
# sys.path.append('..')
# from src.snowflake_connector import get_snowflake_session
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from src.snowflake_connector import get_snowflake_session

st.set_page_config(page_title="AI Product Catalog", page_icon="🤖", layout="wide")

# Initialize session
@st.cache_resource
def init_connection():
    return get_snowflake_session()

session = init_connection()

# Title
st.title("🤖 AI-Powered Product Catalog")
st.markdown("### Powered by Snowflake Cortex AI")

# Sidebar
with st.sidebar:
    st.header("Navigation")
    page = st.radio("Choose a page:", 
                    ["🏠 Home", "🔍 Semantic Search", "💬 Ask Questions", 
                     "📊 Analytics", "📝 Marketing Tools"])

# ==================== HOME PAGE ====================
if page == "🏠 Home":
    st.header("Welcome to the AI Product Catalog")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        total_products = session.sql("SELECT COUNT(*) FROM CATEGORIZED_PRODUCTS").collect()[0][0]
        st.metric("Total Products", total_products)
    
    with col2:
        categories = session.sql("SELECT COUNT(DISTINCT CATEGORY) FROM CATEGORIZED_PRODUCTS").collect()[0][0]
        st.metric("Categories", categories)
    
    with col3:
        avg_price = session.sql("SELECT ROUND(AVG(PRICE), 2) FROM CATEGORIZED_PRODUCTS").collect()[0][0]
        st.metric("Avg Price", f"${avg_price}")
    
    st.subheader("Recent Products")
    products_df = session.sql("""
        SELECT PRODUCT_ID, CLEAN_PRODUCT_NAME, CATEGORY, PRICE, ENHANCED_DESCRIPTION
        FROM CATEGORIZED_PRODUCTS
        ORDER BY PRODUCT_ID DESC
        LIMIT 10
    """).to_pandas()
    st.dataframe(products_df, use_container_width=True)

# ==================== SEMANTIC SEARCH PAGE ====================
elif page == "🔍 Semantic Search":
    st.header("Semantic Product Search")
    st.markdown("Search products using natural language - finds similar items based on meaning, not just keywords")
    
    search_query = st.text_input("What are you looking for?", 
                                 placeholder="e.g., laptop for video editing")
    top_n = st.slider("Number of results", 1, 10, 5)
    
    if st.button("Search", type="primary"):
        if search_query:
            with st.spinner("Searching..."):
                # results = session.sql(f"""
                #     SELECT * FROM TABLE(SEMANTIC_SEARCH('{search_query}', {top_n}))
                # """).to_pandas()
                # results = session.call('SEMANTIC_SEARCH', search_query, top_n)

                # result = session.sql(f""" CALL SEMANTIC_SEARCH('{search_query}', {top_n})""").collect()
                # results = session.create_dataframe(result)
                
                # st.success(f"Found {len(results)} relevant products")
                # For semantic search
                session.sql(f"CALL SEMANTIC_SEARCH('{search_query}', {top_n})").collect()

                results = session.sql("SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))").to_pandas()

                st.success(f"Found {len(results)} relevant products")
                
                for idx, row in results.iterrows():
                    with st.container():
                        col1, col2 = st.columns([3, 1])
                        with col1:
                            st.subheader(row['CLEAN_PRODUCT_NAME'])
                            st.write(row['ENHANCED_DESCRIPTION'])
                            st.caption(f"Category: {row['CATEGORY']}")
                        with col2:
                            st.metric("Price", f"${row['PRICE']}")
                            st.metric("Match", f"{row['SIMILARITY_SCORE']:.2%}")
                        st.divider()

# ==================== ASK QUESTIONS PAGE ====================
elif page == "💬 Ask Questions":
    st.header("Ask the Product Catalog")
    st.markdown("Ask natural language questions about our products")
    
    question = st.text_area("Your question:", 
                            placeholder="e.g., What's the best laptop under $1500?",
                            height=100)
    
    if st.button("Get Answer", type="primary"):
        if question:
            with st.spinner("Thinking..."):
                # answer = session.sql(f"""
                #     SELECT ASK_PRODUCT_CATALOG('{question}')
                # """).collect()[0][0]
                answer = session.call('ASK_PRODUCT_CATALOG', question)
                
                st.success("Answer:")
                st.write(answer)
    
    st.divider()
    st.subheader("Example Questions")
    examples = [
        "What are the most expensive products?",
        "Compare the available smartphones",
        "I need headphones for working out",
        "What gaming products do you have?"
    ]
    
    for example in examples:
        if st.button(example):
            with st.spinner("Thinking..."):
                # answer = session.sql(f"""
                #     SELECT ASK_PRODUCT_CATALOG('{example}')
                # """).collect()[0][0]
                session.sql(f"CALL ASK_PRODUCT_CATALOG('{example}')").collect()
                answer = session.sql("SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))").collect()[0][0]
                st.success("Answer:")
                st.write(answer)

# ==================== ANALYTICS PAGE ====================
elif page == "📊 Analytics":
    st.header("Product Analytics")
    
    analytics_df = session.sql("""
        SELECT * FROM CATEGORY_ANALYTICS
    """).to_pandas()
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("Products by Category")
        st.bar_chart(analytics_df.set_index('CATEGORY')['PRODUCT_COUNT'])
    
    with col2:
        st.subheader("Average Price by Category")
        st.bar_chart(analytics_df.set_index('CATEGORY')['AVG_PRICE'])
    
    st.subheader("Detailed Analytics")
    st.dataframe(analytics_df, use_container_width=True)
    
    if st.button("Generate AI Insights", type="primary"):
        with st.spinner("Analyzing data..."):
            insights = session.sql("""
                WITH analytics_summary AS (
                    SELECT LISTAGG(
                        CATEGORY || ': ' || PRODUCT_COUNT || ' products, Avg Price: $' || AVG_PRICE,
                        '\\n'
                    ) as SUMMARY
                    FROM CATEGORY_ANALYTICS
                )
                SELECT SNOWFLAKE.CORTEX.COMPLETE(
                    'mistral-large',
                    'Analyze this product catalog data and provide 5 key business insights:\\n\\n' || SUMMARY
                )
                FROM analytics_summary
            """).collect()[0][0]
            
            st.success("AI-Generated Insights:")
            st.write(insights)

# ==================== MARKETING TOOLS PAGE ====================
elif page == "📝 Marketing Tools":
    st.header("AI Marketing Tools")
    
    tab1, tab2 = st.tabs(["Product Comparison", "Marketing Email"])
    
    with tab1:
        st.subheader("Generate Product Comparison")
        categories = session.sql("""
            SELECT DISTINCT CATEGORY FROM CATEGORIZED_PRODUCTS ORDER BY CATEGORY
        """).to_pandas()['CATEGORY'].tolist()
        
        selected_category = st.selectbox("Select Category", categories)
        
        if st.button("Generate Comparison", type="primary"):
            with st.spinner("Generating comparison..."):
                # comparison = session.sql(f"""
                #     SELECT COMPARE_PRODUCTS('{selected_category}')
                # """).collect()[0][0]
                session.sql(f"CALL COMPARE_PRODUCTS('{selected_category}')").collect()
                comparison = session.sql("SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))").collect()[0][0]
                
                st.success("Product Comparison:")
                st.write(comparison)
    
    with tab2:
        st.subheader("Generate Marketing Email")
        products = session.sql("""
            SELECT PRODUCT_ID, CLEAN_PRODUCT_NAME 
            FROM CATEGORIZED_PRODUCTS 
            ORDER BY CLEAN_PRODUCT_NAME
        """).to_pandas()
        
        product_dict = dict(zip(products['CLEAN_PRODUCT_NAME'], products['PRODUCT_ID']))
        selected_product = st.selectbox("Select Product", list(product_dict.keys()))
        
        if st.button("Generate Email", type="primary"):
            product_id = product_dict[selected_product]
            with st.spinner("Writing email..."):
                # email = session.sql(f"""
                #     SELECT GENERATE_MARKETING_EMAIL({product_id})
                # """).collect()[0][0]
                session.sql(f"CALL GENERATE_MARKETING_EMAIL({product_id})").collect()
                email = session.sql("SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))").collect()[0][0]
                
                st.success("Marketing Email:")
                st.write(email)

# Footer
st.divider()
st.caption("Built with Snowflake Cortex AI | Powered by Mistral & E5 Models")