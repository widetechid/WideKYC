package com.wide.mobile.wkycdemo;

import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;
import com.wide.mobile.widekyc.api.WKYC;
import com.wide.mobile.widekyc.api.WKYCCallback;
import com.wide.mobile.widekyc.api.WKYCConfig;
import com.wide.mobile.widekyc.api.WKYCConstants;
import com.wide.mobile.widekyc.api.WKYCID;
import com.wide.mobile.widekyc.api.WKYCRequest;
import com.wide.mobile.widekyc.api.WKYCResponse;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;

public class MobileSDKActivity extends AppCompatActivity {
    final static String TAG = "MobileSDKActivity";
    private Context context;
    private Handler mHandler;
    private LinearLayout loader, serviceLevelLayout;
    private EditText host, api, serviceLevel;
    private Spinner productLists;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.context = this;
        this.mHandler = new Handler();

        initActivity();
    }

    private void initActivity(){
        setContentView(R.layout.mobile_sdk_activity);
        host = findViewById(R.id.init_host);
        api = findViewById(R.id.init_api);
        serviceLevel = findViewById(R.id.init_service_level);
        serviceLevelLayout = findViewById(R.id.init_service_level_layout);
        loader = findViewById(R.id.mainLoader);

        host.setText(Helper.getHostInput(context));
        api.setText(Helper.getApiInput(context));

        host.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) { }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                Helper.setHostInput(context,charSequence.toString());
            }

            @Override
            public void afterTextChanged(Editable editable) { }
        });
        api.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) { }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                Helper.setApiInput(context,charSequence.toString());
            }

            @Override
            public void afterTextChanged(Editable editable) { }
        });

        productLists = findViewById(R.id.productLists);
        String[] items = new String[]{
                WKYCConstants.PASSIVE_LIVENESS,
                WKYCConstants.ID_RECOGNIZE,
                WKYCConstants.ID_VALIDATION,
                WKYCConstants.PASSPORT_RECOGNIZE,
                WKYCConstants.KK_RECOGNIZE
        };
        ArrayAdapter adapter = new ArrayAdapter(context, R.layout.wkyc_product_list, items);
        productLists.setAdapter(adapter);
        productLists.setSelection(0);

        productLists.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String currentProduct = productLists.getSelectedItem().toString();
                if(currentProduct.equalsIgnoreCase(WKYCConstants.PASSIVE_LIVENESS)){
                    serviceLevel.setText(WKYCConstants.SL_PASSIVE_LIVENESS_MED);
                    serviceLevelLayout.setVisibility(View.VISIBLE);
                }
                else if(currentProduct.equalsIgnoreCase(WKYCConstants.ID_RECOGNIZE)){
                    serviceLevel.setText(WKYCConstants.SL_ID_RECOGNIZE_ENT);
                    serviceLevelLayout.setVisibility(View.VISIBLE);
                }
                else if(currentProduct.equalsIgnoreCase(WKYCConstants.ID_VALIDATION)){
                    serviceLevel.setText(WKYCConstants.SL_ID_VALIDATION_UI);
                    serviceLevelLayout.setVisibility(View.VISIBLE);
                }
                else if(currentProduct.equalsIgnoreCase(WKYCConstants.PASSPORT_RECOGNIZE)){
                    serviceLevel.setText(WKYCConstants.SL_PASSPORT_RECOGNIZE_ENT);
                    serviceLevelLayout.setVisibility(View.VISIBLE);
                }
                else if(currentProduct.equalsIgnoreCase(WKYCConstants.KK_RECOGNIZE)){
                    serviceLevel.setText(WKYCConstants.SL_KK_RECOGNIZE_ENT);
                    serviceLevelLayout.setVisibility(View.VISIBLE);
                }
                else{
                    serviceLevelLayout.setVisibility(View.GONE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }

    public void goBack(View view){
        finish();
    }

    public void startKyc(View view){
        loader.setVisibility(View.VISIBLE);
        runOnIoThread(new Runnable() {
            @Override
            public void run() {
                String result = initMerchant();
                if (result.length() == 3) {
                    showToast("network exception, please try again. error code : "+result);
                    return;
                }
                else if(result.contains("Error")){
                    showToast(result);
                    return;
                }

                try{
                    JSONObject resultJson = new JSONObject(result);
                    if(resultJson.getString("statusCode").equalsIgnoreCase("ERROR")){
                        showToast(resultJson.getString("responseStatusDetails"));
                    }
                    else{
                        /**
                         * You need to provide WKYCID for product 02 with service level 62021 to work
                         */
                        WKYCID wkycid = new WKYCID();
                        wkycid.nik = "3203012503770011";
                        wkycid.name = "Guohui Chen";
                        wkycid.birthdate = "25-03-1977";
                        wkycid.birthplace = "Fujian";
                        wkycid.address = "Jl Selamet, Perumahan Rancabali";

                        final WKYC wkyc = WKYC.getInstance(context);
                        final WKYCRequest request = new WKYCRequest();
                        request.wkycConfig = new Gson().fromJson(resultJson.getString("content"), WKYCConfig.class);
                        request.clientConfig = new HashMap<>();
                        request.clientConfig.put(WKYCConstants.LOCALE, WKYCConstants.LANG_EN);
                        request.clientConfig.put(WKYCConstants.FLAT_SURFACE_ONLY, true);
                        request.clientConfig.put(WKYCConstants.UI_CONFIG_PATH, "config.json");
                        request.wkycid = wkycid;
                        mHandler.postAtFrontOfQueue(new Runnable() {
                            @Override
                            public void run() {
                                Log.d(TAG, "Start WideKYC");
                                wkyc.start(request, new WKYCCallback() {
                                    @Override
                                    public void onCompleted(WKYCResponse response) {
                                        try{
                                            if(response.status.equalsIgnoreCase("ERROR")){
                                                showResponse(context, request.wkycConfig.trxId, response.data.toString());
                                            }
                                            else{
                                                /**
                                                 * this is how to get processed image from product 00 & 01
                                                 * image will be send only onCompleted callback
                                                 * String imagePath = response.data.getString("WKYCConstants.PROCESSED_IMAGE_PATH");
                                                 * String imageBase64 = getBase64FromPath(imagePath);
                                                 */
                                                checkResult(response.data.getString(WKYCConstants.TRX_ID));
                                            }
                                        }
                                        catch (JSONException e){
                                            loader.setVisibility(View.INVISIBLE);
                                            e.printStackTrace();
                                        }
                                    }

                                    @Override
                                    public void onInterrupted(WKYCResponse response) {
                                        showToast(response.message);
                                    }

                                    @Override
                                    public void onCancel(WKYCResponse response) {
                                        showToast(response.message);
                                    }
                                });
                            }
                        });
                    }
                }
                catch (Exception e){
                    loader.setVisibility(View.INVISIBLE);
                    e.printStackTrace();
                }
            }
        });
    }

    private void checkResult(String transactionId) {
        runOnIoThread(new Runnable() {
            @Override
            public void run() {
                try{
                    LocalRequest request = new LocalRequest();
                    String requestUrl = host.getText().toString() + "checkResult";
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put(WKYCConstants.TRX_ID, transactionId);
                    String requestData = jsonObject.toString();
                    String result = request.request(requestUrl, requestData, null);
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

    private String initMerchant() {
        try{
            LocalRequest local = new LocalRequest();
            String requestUrl = host.getText().toString() +api.getText().toString();
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(WKYCConstants.META_INFO, WKYC.getMetaInfo(context));
            jsonObject.put(WKYCConstants.PRODUCT, productLists.getSelectedItem().toString());
            jsonObject.put(WKYCConstants.SERVICE_LEVEL, serviceLevel.getText().toString());
            String requestData = jsonObject.toString();
            String result = local.request(requestUrl, requestData, null);
            return result;
        }
        catch (Exception e){
            e.printStackTrace();
            return "Error : " + e.getMessage();
        }
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

    private String getBase64FromPath(String fullPath){
        try{
            File file = new File(fullPath);
            Bitmap bitmap = BitmapFactory.decodeStream(new FileInputStream(file));
            ByteArrayOutputStream byteArrayOS = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, (OutputStream)byteArrayOS);

            return Base64.encodeToString(byteArrayOS.toByteArray(), 0);
        }
        catch (IOException e){
            e.printStackTrace();
            return "";
        }
    }
}
