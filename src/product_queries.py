from snowflake_connector import get_snowflake_session

def semantic_search(query, top_n=5):
    """Perform semantic search on products"""
    session = get_snowflake_session()
    result = session.sql(f"""
        SELECT * FROM TABLE(SEMANTIC_SEARCH('{query}', {top_n}))
    """).collect()
    session.close()
    return result

def ask_catalog(question):
    """Ask a question using RAG"""
    session = get_snowflake_session()
    result = session.sql(f"""
        SELECT ASK_PRODUCT_CATALOG('{question}')
    """).collect()
    session.close()
    return result[0][0]

def get_all_products():
    """Get all products"""
    session = get_snowflake_session()
    result = session.table("CATEGORIZED_PRODUCTS").collect()
    session.close()
    return result

def get_category_analytics():
    """Get category analytics"""
    session = get_snowflake_session()
    result = session.table("CATEGORY_ANALYTICS").collect()
    session.close()
    return result

# Example usage
if __name__ == "__main__":
    print("🔍 Testing Semantic Search...")
    results = semantic_search("gaming laptop", 3)
    for r in results:
        print(f"- {r['CLEAN_PRODUCT_NAME']}: ${r['PRICE']}")
    
    print("\n💬 Testing Q&A...")
    answer = ask_catalog("What's the cheapest phone?")
    print(answer)