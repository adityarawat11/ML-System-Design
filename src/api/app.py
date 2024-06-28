from fastapi import FastAPI
from langchain.prompts import ChatPromptTemplate
from langchain_openai import AzureChatOpenAI
from langserve import add_routes
import uvicorn
import os
from langchain_community.llms import Ollama
from dotenv import load_dotenv

load_dotenv()
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

# Langsmith tracking
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = os.getenv("LANGCHAIN_API_KEY")
os.environ["LANGCHAIN_PROJECT"] = "side_project"

app = FastAPI(
    title="Lanchain serve",
    version="1.0",
    description="A simple API service"
)

# OpenAI LLM
model = AzureChatOpenAI(model_name='azure-gpt-35-turbo',
                        openai_api_key=os.environ["OPENAI_API_KEY"],
                        azure_endpoint="https://openai-ds-platform.openai.azure.com/",
                        openai_api_version="2023-05-15")
# Llama 3 Model
llm = Ollama(model='llama3')
prompt1 = ChatPromptTemplate.from_template("Write me an essay about :{topic} using 100 words")
prompt2 = ChatPromptTemplate.from_template("Write me a poem about :{topic} using 50 words")

add_routes(
    app,
    prompt1 | model,
    path="/essay"
)
add_routes(
    app,
    prompt2 | llm,
    path="/poem"
)


def main():
    uvicorn.run(app, host="localhost", port=8080)


if __name__ == "__main__":
    main()
