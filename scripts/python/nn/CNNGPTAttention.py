"""
A simple CNN + GPT-style (causal) Self-Attention model for image classification.
The CNN extracts spatial features, and a stack of causal self-attention blocks
models relationships between spatial regions in an autoregressive (causal) manner.

Copyright (c) 2025 Olaf Reitmaier

Inspired by: 

Künstliche Neuronale Netze im Überblick 8: Hybride Architekturen
By Prof. Dr. Michael Stal (11.09.2025)
https://www.heise.de/blog/Kuenstliche-Neuronale-Netze-im-Ueberblick-8-Hybride-Architekturen-10639119.html

"""

import torch
import torch.nn as nn
import torch.nn.functional as F

class CausalSelfAttention(nn.Module):
    def __init__(self, embed_dim, num_heads):
        super().__init__()
        self.attn = nn.MultiheadAttention(embed_dim=embed_dim, num_heads=num_heads, batch_first=True)

    def forward(self, x):
        # x: (batch, seq_len, embed_dim)
        seq_len = x.size(1)
        # Causal mask: only attend to previous and current positions
        mask = torch.triu(torch.ones(seq_len, seq_len, device=x.device), diagonal=1).bool()
        attn_out, _ = self.attn(x, x, x, attn_mask=mask)
        return attn_out

class CNNGPTAttention(nn.Module):
    def __init__(self, cnn_out_dim=128, num_heads=4, num_layers=2, num_classes=10):
        super().__init__()
        # CNN feature extractor
        self.cnn = nn.Sequential(
            nn.Conv2d(3, 64, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(64, cnn_out_dim, 3, padding=1),
            nn.ReLU()
        )
        # Stack of causal self-attention blocks
        self.transformer_blocks = nn.ModuleList([
            CausalSelfAttention(cnn_out_dim, num_heads) for _ in range(num_layers)
        ])
        # Classifier
        self.classifier = nn.Linear(cnn_out_dim, num_classes)

    def forward(self, images):
        # images: (batch, C, H, W)
        features = self.cnn(images)  # (b, cnn_out_dim, H', W')
        b, d, h, w = features.shape
        # Flatten spatial dimensions into sequence
        seq = features.view(b, d, h * w).permute(0, 2, 1)  # (b, seq_len, d)
        # Pass through causal self-attention blocks
        for block in self.transformer_blocks:
            seq = block(seq)
        # Pool across tokens by taking the mean
        pooled = seq.mean(dim=1)  # (b, d)
        logits = self.classifier(pooled)  # (b, num_classes)
        return logits

def main():
    # Test the CNNGPTAttention model with dummy data
    model = CNNGPTAttention()
    dummy_images = torch.randn(4, 3, 32, 32)  # Batch of 4 images
    outputs = model(dummy_images)  # (4, 10)
    print(outputs.shape)  # Should print: torch.Size([4, 10])

if __name__ == "__main__":
    main()
