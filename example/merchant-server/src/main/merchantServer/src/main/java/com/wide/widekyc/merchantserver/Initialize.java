package com.wide.ekycaggr.merchantserver;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/initMerchant")
public class Initialize extends HttpConnection{

    @PostMapping(path= "", consumes = "application/json", produces = "application/json")
    ResponseEntity<Map> initial(@RequestBody RequestParams requestParams) {
        Map map = new HashMap();
        int responseCode = 0;

        try {
            requestParams.setTransactionRefNo("<mandatory_unique_ref_no>");
            ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
            String json = ow.writeValueAsString(requestParams);

            HttpURLConnection con = getHttpURLConnection("initialize");

            try (OutputStream os = con.getOutputStream()) {
                byte[] input = json.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            responseCode = con.getResponseCode();
            System.out.println("Response Code : " + responseCode);

            try (BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()))) {

                String line;
                StringBuilder response = new StringBuilder();

                while ((line = in.readLine()) != null) {
                    response.append(line);
                }

                map = new ObjectMapper().readValue(response.toString(), Map.class);
                //print result
                System.out.println("response ==== " + response.toString());

                return ResponseEntity
                        .status(HttpStatus.OK)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(map);
            }
        }catch(IOException ioException){
            System.out.println("error ==== " + ioException.getMessage());

            return ResponseEntity
                    .status(responseCode)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(map);
        }
    }

}
