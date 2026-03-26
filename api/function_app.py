import json
import logging
import azure.functions as func

from shared.cosmos_client import get_container_client

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.route(route="items", methods=["GET", "POST"])
def items(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("HTTP trigger 'items' wurde aufgerufen.")

    container = get_container_client()

    if req.method == "GET":
        query = "SELECT * FROM c"
        results = list(container.query_items(
            query=query,
            enable_cross_partition_query=True
        ))

        return func.HttpResponse(
            json.dumps(results),
            mimetype="application/json",
            status_code=200
        )

    if req.method == "POST":
        try:
            body = req.get_json()
        except ValueError:
            return func.HttpResponse(
                "Ungültiges JSON im Request Body.",
                status_code=400
            )

        if "id" not in body:
            return func.HttpResponse(
                "Feld 'id' fehlt.",
                status_code=400
            )

        container.create_item(body)

        return func.HttpResponse(
            json.dumps({"message": "Item erstellt", "item": body}),
            mimetype="application/json",
            status_code=201
        )

    return func.HttpResponse("Methode nicht erlaubt.", status_code=405)