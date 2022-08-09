package com.wide.mobile.wkycdemo;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import com.wide.mobile.widekyc.api.WKYCConstants;

import org.json.JSONObject;


public class InitApiActivity extends AppCompatActivity {
    final static String TAG = "InitApiActivity";
    private Context context;
    private LinearLayout loader;
    private EditText host, api;
    private Spinner productLists;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.context = this;

        initActivity();
    }

    private void initActivity(){
        setContentView(R.layout.init_api_activity);
        host = findViewById(R.id.init_host);
        api = findViewById(R.id.init_api);
        loader = findViewById(R.id.mainLoader);
        productLists = findViewById(R.id.productLists);

        String[] items = new String[]{
                WKYCConstants.PASSIVE_LIVENESS,
                WKYCConstants.ID_RECOGNIZE,
        };
        ArrayAdapter adapter = new ArrayAdapter(context, R.layout.wkyc_product_list, items);
        productLists.setAdapter(adapter);
        productLists.setSelection(0);

        productLists.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {

            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }

    public void goBack(View view){
        finish();
    }

    public void startApiInterface(View view){
        loader.setVisibility(View.VISIBLE);
        runOnIoThread(new Runnable() {
            @Override
            public void run() {
                String result = initRequest();
                if (TextUtils.isEmpty(result)) {
                    showToast("network exception, please try again");
                    return;
                }
                try{
                    JSONObject resultJson = new JSONObject(result);
                    if(resultJson.getString("statusCode").equalsIgnoreCase("ERROR")){
                        showToast("Service Error");
                    }
                    else{
                        JSONObject content = new JSONObject(resultJson.getString("content"));

                        Intent intent = new Intent(context, WebViewActivity.class);
                        intent.putExtra("product", content.getString("product"));
                        intent.putExtra("trxId", content.getString("trxId"));
                        activityResultLauncher.launch(intent);
                        loader.setVisibility(View.INVISIBLE);
                    }
                }
                catch (Exception e){
                    loader.setVisibility(View.INVISIBLE);
                    e.printStackTrace();
                }
            }
        });
    }

    // You can do the assignment inside onAttach or onCreate, i.e, before the activity is displayed
    ActivityResultLauncher<Intent> activityResultLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == Activity.RESULT_OK) {
                    // There are no request codes
                    Intent data = result.getData();
                    checkResult(data.getStringExtra("trxId"));
                }
            });


    private String initRequest() {
        try{
            LocalRequest local = new LocalRequest();
            String requestUrl = host.getText().toString() + api.getText().toString();
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(WKYCConstants.META_INFO, "");
            jsonObject.put(WKYCConstants.PRODUCT, productLists.getSelectedItem().toString());
            jsonObject.put(WKYCConstants.SERVICE_LEVEL, "");
            jsonObject.put("chanel", "WEBSDK");
            String requestData = jsonObject.toString();
            String token = "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6STFOaUo5LmV5SnpkV0lpT2lJMll6ZGhNVEk1TlMxaFpXTTRMVFJsWVdZdFltRXpPUzFqTVdRNE4yRTFaakV5Wm1FaUxDSnBjM01pT2lKUFYxVjRUbTFKTTFwcVNYUmFSRVpxV1drd01FNVVXbWxNVjBacFRXcFZkRTF0VVhsWmVrRjVXV3BGTTAxSFdUSWlMQ0psYldGcGJDSTZJbXhwYkdsaGJtbDBaWE4wUUhCeWFXMWxZMkZ6YUM1amJ5NXBaQ0o5LnFWNmNibi1BcnE5VGVoNDQ3NDNNaVhseVFNWGRmU2xtRm1WbEpKaENuNTQ=";
            String result = local.request(requestUrl, requestData, token);

            return result;
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    private void checkResult(String transactionId) {
        runOnIoThread(new Runnable() {
            @Override
            public void run() {
                try{
                    LocalRequest request = new LocalRequest();
                    String requestUrl = host.getText().toString() + "/api/checkResult";
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put(WKYCConstants.TRX_ID, transactionId);
                    String requestData = jsonObject.toString();
                    String token = "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6STFOaUo5LmV5SnpkV0lpT2lJMll6ZGhNVEk1TlMxaFpXTTRMVFJsWVdZdFltRXpPUzFqTVdRNE4yRTFaakV5Wm1FaUxDSnBjM01pT2lKUFYxVjRUbTFKTTFwcVNYUmFSRVpxV1drd01FNVVXbWxNVjBacFRXcFZkRTF0VVhsWmVrRjVXV3BGTTAxSFdUSWlMQ0psYldGcGJDSTZJbXhwYkdsaGJtbDBaWE4wUUhCeWFXMWxZMkZ6YUM1amJ5NXBaQ0o5LnFWNmNibi1BcnE5VGVoNDQ3NDNNaVhseVFNWGRmU2xtRm1WbEpKaENuNTQ=";
                    String result = request.request(requestUrl, requestData, token);
                    if (TextUtils.isEmpty(result)) {
                        showToast("Failed checkResult : network exception, please try again");
                        return;
                    }
                    else{
                        showResponse(context, transactionId, result);
                    }
                }
                catch (Exception e){
                    e.printStackTrace();
                }
            }
        });
    }

    private void showResponse(Context context, String trxId, String response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                loader.setVisibility(View.INVISIBLE);
                AlertDialog alertDialog = new AlertDialog.Builder(context)
                        .setTitle("Result")
                        .setMessage(response)
                        .setNegativeButton("Ok", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                ClipboardManager myClipboard = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
                                ClipData myClip;
                                String text = trxId;
                                myClip = ClipData.newPlainText("text", text);
                                myClipboard.setPrimaryClip(myClip);
                                dialog.dismiss();
                            }
                        })
                        .create();
                alertDialog.setCancelable(false);
                alertDialog.setCanceledOnTouchOutside(false);
                alertDialog.show();
            }
        });
    }

    private void showToast(String message){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                loader.setVisibility(View.INVISIBLE);
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void runOnIoThread(Runnable runnable) {
        Thread thread = new Thread(runnable);
        thread.start();
    }
}