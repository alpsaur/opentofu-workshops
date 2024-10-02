// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  
  const headers = event.headers || {};
  const acceptHeader = headers['accept'] || headers['Accept'] || '';

  // Check if the request prefers HTML
  if (acceptHeader.includes('text/html')) {
    const html = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello, World!</title>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>If you dont see this, then you are not using a browser.</p>
</body>
</html>
    `;

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html',
      },
      body: html,
    };
  } else {
    // Return JSON for API calls or when HTML is not preferred
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: 'Hello, World!',
      }),
    };
  }
};
