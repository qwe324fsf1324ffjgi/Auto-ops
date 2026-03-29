import json
import logging
import os
import urllib.error
import urllib.request

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ssm = boto3.client("ssm")

EC2_PUBLIC_IP = os.environ.get("EC2_PUBLIC_IP", "").strip()
EC2_INSTANCE_ID = os.environ.get("EC2_INSTANCE_ID", "").strip()
DOCKER_CONTAINER_NAME = os.environ.get("DOCKER_CONTAINER_NAME", "autoops-nginx").strip()

HEALTH_URL = f"http://{EC2_PUBLIC_IP}"


def check_health(url: str) -> dict:
    try:
        logger.info(f"Checking health URL: {url}")

        request = urllib.request.Request(url, method="GET")

        with urllib.request.urlopen(request, timeout=10) as response:
            status_code = response.getcode()

            logger.info(f"Health check returned status code: {status_code}")

            return {
                "healthy": status_code == 200,
                "status_code": status_code,
                "error": None
            }

    except urllib.error.HTTPError as http_error:
        logger.error(f"HTTP error during health check: {http_error}")
        return {
            "healthy": False,
            "status_code": http_error.code,
            "error": str(http_error)
        }

    except urllib.error.URLError as url_error:
        logger.error(f"URL error during health check: {url_error}")
        return {
            "healthy": False,
            "status_code": None,
            "error": str(url_error)
        }

    except Exception as exc:
        logger.exception("Unexpected error during health check")
        return {
            "healthy": False,
            "status_code": None,
            "error": str(exc)
        }


def restart_container(instance_id: str, container_name: str) -> dict:
    commands = [
        f"docker restart {container_name} || docker start {container_name}"
    ]

    logger.info(
        f"Sending SSM command to restart container '{container_name}' on instance '{instance_id}'"
    )

    response = ssm.send_command(
        InstanceIds=[instance_id],
        DocumentName="AWS-RunShellScript",
        Parameters={"commands": commands},
        Comment="AutoOps self-healing restart of nginx Docker container"
    )

    command_id = response["Command"]["CommandId"]

    logger.info(f"SSM command sent successfully. Command ID: {command_id}")

    return {
        "command_id": command_id,
        "commands": commands
    }


def lambda_handler(event, context):
    logger.info("AutoOps Lambda execution started")
    logger.info(f"Received event: {json.dumps(event)}")

    if not EC2_PUBLIC_IP:
      return {
          "statusCode": 500,
          "body": json.dumps({"message": "Missing EC2_PUBLIC_IP environment variable"})
      }

    if not EC2_INSTANCE_ID:
      return {
          "statusCode": 500,
          "body": json.dumps({"message": "Missing EC2_INSTANCE_ID environment variable"})
      }

    health_result = check_health(HEALTH_URL)

    if health_result["healthy"]:
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Application is healthy",
                "health_url": HEALTH_URL,
                "instance_id": EC2_INSTANCE_ID,
                "status_code": health_result["status_code"],
                "action_taken": "none"
            })
        }

    try:
        restart_result = restart_container(
            instance_id=EC2_INSTANCE_ID,
            container_name=DOCKER_CONTAINER_NAME
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Application was unhealthy. Restart command sent.",
                "health_url": HEALTH_URL,
                "instance_id": EC2_INSTANCE_ID,
                "status_code": health_result["status_code"],
                "health_error": health_result["error"],
                "action_taken": "docker_restart",
                "container_name": DOCKER_CONTAINER_NAME,
                "ssm_command_id": restart_result["command_id"]
            })
        }

    except Exception as exc:
        logger.exception("Failed to send restart command through SSM")

        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Application unhealthy and self-healing failed",
                "health_url": HEALTH_URL,
                "instance_id": EC2_INSTANCE_ID,
                "status_code": health_result["status_code"],
                "health_error": health_result["error"],
                "action_taken": "restart_failed",
                "restart_error": str(exc)
            })
        }