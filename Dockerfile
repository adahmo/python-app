FROM python:3.9-slim
#Set working directory
WORKDIR /app
#Copy the files
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
#Run the app
CMD [ "python", "appy.py" ]
# Expose port 8000
EXPOSE 800
