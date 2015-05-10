# DeepLink Interoperability (dpl.io) Standard

The Deep Link Interoperability (dpl.io) standard sets out a light-weight way of adding consistent formatting for encoding complex objects, enabling 'back' functionality and powering attribution of incoming deep links.

## V1

All dpl.io parameters are passed as query parameters. Where the host is used to define the standard used to interpret a deep link, the host `dpl.io` should be used. This is not a mandatory part of the standard.

### Unencoded Query Parameters
Basic dpl.io functionality is available through unencoded query parameters as defined below. These include definition of the standard version as well as the callback URL and attribution token.

- `dpl:callback-url`: A URL to be considered as the 'back' button action
- `dpl:protocol-version`: The version of the dpl.io protocol used to encode the deep link
- `dpl:attribution-token`: A token to consider as the application's 'last touch' referrer. (More in Full Referrer Data)

### Encoding Complex Objects
The dpl.io standard allows for the passing of complex objects between apps by JSON-encoding them and using a defined field to mark up encoded fields.

The `dpl:json-encoded-fields` query parameter defines any other query parameters of the deep link that should be JSON-decoded and made available to the application as complex types.

By default, the following fields should be JSON-decoded:

- `dpl:json-encoded-fields`: This field itself is an encoded array and should always be decoded first
- `dpl:referral-data`: This contains a dictionary of referrer information defined in Full Referrer Data

### Full Referrer Data
The dictionary in the query parameter `dpl:referral-data` contains more granular information about the referring application. Specifically:

- `dpl:referrer-application-itunes-id`: The iTunes ID of the referring application
- `dpl:referrer-application-play-id`: The iTunes ID of the referring application
- `dpl:referrer-application-name`: The display name of the referring application
- `dpl:referrer-callback-display-title`: The title of the action button that invokes the URL in the `dpl:callback-url` query parameter.

### Query Parameter Structure
This is the full structure of the query parameters defined in V1 of the `dpl.io` standard.

```js
// The version of the protocol
- "dpl:protocol-version":        1.0


// The URL to call to go 'back'
- "dpl:callback-url":            "callingapp://dpl.io/action_complete"


// The token to use as the 'last-touch' referrer
- "dpl:attribution-token":       "tok-abc123"



// The names of fields to decode from JSON
- "dpl:json-encoded-fields":(*)  ["dpl:referral-data"]


// Additional data about the referring app. (You can add more here)
- "dpl:referral-data":(*)        { "dpl:referrer-application-id":         "1234567",
                                   "dpl:referrer-application-name":       "Calling App",
                                   "dpl:referrer-callback-display-title": "Done" }


NOTE: (*) denotes that the field is JSON-encoded
```
