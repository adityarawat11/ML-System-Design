import requests
import streamlit as st


def get_openai_response(input_text):
    response = requests.post("http://localhost:8080/essay/invoke",
                             json={'input': {'topic': input_text}})
    return response.json()["output"]["content"]


def get_llama_response(input_text):
    response = requests.post("http://localhost:8080/poem/invoke",
                             json={'input': {'topic': input_text}})
    return response.json()["output"]


st.title("Lanchain Demo")
input_text = st.text_input("Write an essay on:")
input_text1 = st.text_input("Write a poem on:")

if input_text1:
    st.write(get_llama_response(input_text1))
if input_text:
    st.write(get_openai_response(input_text))

