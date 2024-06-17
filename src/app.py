from langchain_openai import ChatOpenAI, AzureChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

import streamlit as st
import os
from dotenv import load_dotenv

# from logging import getLogger
load_dotenv()
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = os.getenv("LANGCHAIN_API_KEY")

# Prompt Template
prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "You are a helpful assistant. Please response to the user queries"),
        ("user", "Question:{question}")
    ]
)
# Streamlit Framework

st.title("Langchain Demo with openAI")
input_text = st.text_input("Search the topic you want")

# OpenAI LLM
llm = AzureChatOpenAI(model_name='azure-gpt-35-turbo',
                      openai_api_key=os.environ["OPENAI_API_KEY"],
                      azure_endpoint="https://openai-ds-platform.openai.azure.com/",
                      openai_api_version="2023-05-15")