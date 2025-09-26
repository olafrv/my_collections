"""
A simple CNN + Self-Attention model for image classification.
The CNN extracts spatial features, and the self-attention layer
models relationships between different spatial regions.

Source: 

Künstliche Neuronale Netze im Überblick 8: Hybride Architekturen
By Prof. Dr. Michael Stal (11.09.2025)
https://www.heise.de/blog/Kuenstliche-Neuronale-Netze-im-Ueberblick-8-Hybride-Architekturen-10639119.html

"""

import torch
import torch.nn as nn
import torch.nn.functional as F  

class CNNAttention(nn.Module):  
    def __init__(self, cnn_out_dim=128, num_heads=4):  
        super().__init__()  
        # CNN feature extractor (similar to before)  
        # https://pytorch.org/docs/stable/generated/torch.nn.Conv2d.html
        self.cnn = nn.Sequential(  
            nn.Conv2d(3, 64, 3, padding=1), # input channels=3 (RGB), output channels=64
            nn.ReLU(),  # activation function
            nn.MaxPool2d(2),  # downsample by factor of 2
            nn.Conv2d(64, cnn_out_dim, 3, padding=1),  # output channels=cnn_out_dim
            nn.ReLU()  # activation function
        )  
        # Multi-head attention layer  
        # https://pytorch.org/docs/stable/generated/torch.nn.MultiheadAttention.html
        self.attn = nn.MultiheadAttention(embed_dim=cnn_out_dim,  
                                          num_heads=num_heads,  
                                          batch_first=True)  
        # Classifier  
        # https://pytorch.org/docs/stable/generated/torch.nn.Linear.html
        self.classifier = nn.Linear(cnn_out_dim, 10)  

    def forward(self, images):  
        # images: (batch, C, H, W)
        features = self.cnn(images)  # (b, cnn_out_dim, H', W')  
        b, d, h, w = features.shape
        # Flatten spatial dimensions into sequence  
        seq = features.view(b, d, h*w).permute(0, 2, 1)  
        # Self-attention over spatial tokens  
        attn_out, _ = self.attn(seq, seq, seq)  # (b, h*w, d)  
        # Pool across tokens by taking the mean  
        pooled = attn_out.mean(dim=1)  # (b, d)  
        logits = self.classifier(pooled)  # (b, 10)  
        return logits  

def main():  
    # Test the CNNAttention model with dummy data  
    model = CNNAttention()  
    dummy_images = torch.randn(4, 3, 32, 32)  # Batch of 4 images  
    outputs = model(dummy_images)  # (4, 10)  
    print(outputs.shape)   # Should print: torch.Size([4, 10])

# Example usage  
if __name__ == "__main__":  
    main()  