FROM python:3.9-slim

WORKDIR /app

# Dependencies install karne ke liye requirements.txt copy karein
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Baaki saara project code aur templates folder copy karein
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]