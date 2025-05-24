import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME;

export const handler = async (event) => {
  // Obtener el ID del cliente de los parámetros de la ruta
  const clienteId = event.pathParameters?.id;

  if (!clienteId) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Se requiere el ID del cliente" })
    };
  }

  const command = new GetCommand({
    TableName: TABLE_NAME,
    Key: {
      "Id_Cliente": clienteId
    }
  });

  try {
    const data = await ddbDocClient.send(command);
    
    if (!data.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: "Cliente no encontrado" })
      };
    }

    return {
      statusCode: 200,
      body: JSON.stringify(data.Item),
      headers: {
        "Content-Type": "application/json"
      }
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Error al obtener los datos del cliente" })
    };
  }
}; 