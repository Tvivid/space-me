package com.spaceme.auth.dto.request;

public record LoginRequest(
        String authorizationCode,
        String deviceToken
) {
}