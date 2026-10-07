FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
# install deps, then remove pip - app doesn't need it at runtime and trivy
# found HIGH vulns in the libraries pip bundles inside itself
RUN pip install --no-cache-dir -r requirements.txt && \
    pip uninstall -y pip

COPY app/ app/

# don't run as root (numeric uid so k8s runAsNonRoot can check it)
RUN useradd --create-home --uid 10001 appuser
USER 10001

EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "-w", "2", "app.main:app"]
