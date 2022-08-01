package com.wide.mobile.wkycexample;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

public class ExampleActivity extends AppCompatActivity {
    final static String TAG = "ExampleActivity";
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.context = this;

        initActivity();
    }

    private void initActivity(){
        setContentView(R.layout.example_activity);
    }

    public void startMobileSdk(View view){
        Intent intent = new Intent(this, MobileSDKActivity.class);
        startActivity(intent);
    }

    public void startApiInterface(View view){
        Intent intent = new Intent(this, InitApiActivity.class);
        startActivity(intent);
    }
}