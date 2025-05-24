import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, ScanCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME;

export const handler = async (event) => {
  const command = new ScanCommand({
    TableName: TABLE_NAME,
    Limit: 100
  });

  try {
    const data = await ddbDocClient.send(command);
    return {
      statusCode: 200,
      body: JSON.stringify(data.Items),
      headers: {
        "Content-Type": "application/json"
      }
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Error al obtener los datos" })
    };
  }
};
