FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY load_data.py .

CMD ["python", "load_data.py"] 