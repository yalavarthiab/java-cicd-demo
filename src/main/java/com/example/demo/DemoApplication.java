package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;

@SpringBootApplication
@RestController
public class DemoApplication {
    public static void main(String[] args){
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/api/hello")
    public Object hello(){
        return java.util.Map.of("message","hello CI/CD");
    }

    @GetMapping("/api/call-python")
    public Object callPython() {
        String pythonUrl = System.getenv().getOrDefault("PYTHON_SERVICE_URL", "http://python:8000/api/time");
        RestTemplate rt = new RestTemplate();
        try {
            ResponseEntity<Object> resp = rt.getForEntity(pythonUrl, Object.class);
            return java.util.Map.of(
                "from", "java-service",
                "python_response", resp.getBody()
            );
        } catch (Exception e) {
            return java.util.Map.of("error", e.getMessage());
        }
    }
}
