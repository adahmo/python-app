FROM python:3.9-slim
#Set work directory
WORKDIR /app
#Copy the files
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY adah.py .
#Run the app adah.py
CMD [ "python", "adah.py" ]
# Expose port test
EXPOSE 8000
