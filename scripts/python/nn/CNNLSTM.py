"""
A simple CNN + LSTM model for video classification.
The CNN extracts spatial features from each frame, 
and the LSTM models temporal dependencies.

Source: 

Künstliche Neuronale Netze im Überblick 8: Hybride Architekturen
By Prof. Dr. Michael Stal (11.09.2025)
https://www.heise.de/blog/Kuenstliche-Neuronale-Netze-im-Ueberblick-8-Hybride-Architekturen-10639119.html

"""
import torch  
import torch.nn as nn  

class CNNLSTM(nn.Module):  
    def __init__(self, num_classes, cnn_out_dim=128, hidden_dim=64):  
        super(CNNLSTM, self).__init__()  
        # A simple CNN that maps (C,H,W) to cnn_out_dim 
        # https://pytorch.org/docs/stable/generated/torch.nn.Conv2d.html 
        self.cnn = nn.Sequential(  
            nn.Conv2d(3, 32, kernel_size=3, padding=1),  
            nn.ReLU(),  
            nn.MaxPool2d(2),            # halves H,W  
            nn.Conv2d(32, 64, 3, padding=1),  
            nn.ReLU(),  
            nn.AdaptiveAvgPool2d((1,1)) # global feature  
        )  
        # Linear layer to flatten the CNN output  
        # https://pytorch.org/docs/stable/generated/torch.nn.Linear.html
        self.fc   = nn.Linear(64, cnn_out_dim)  
        # LSTM to model the temporal sequence of frame features  
        # https://pytorch.org/docs/stable/generated/torch.nn.LSTM.html
        self.lstm = nn.LSTM(input_size=cnn_out_dim,  
                            hidden_size=hidden_dim,  
                            num_layers=1,  
                            batch_first=True)  
        # Final classifier that maps the LSTM output to class logits  
        self.classifier = nn.Linear(hidden_dim, num_classes)  

    def forward(self, videos):  
        # videos: (batch, seq_len, C, H, W)  
        b, t, c, h, w = videos.shape  
        # Merge batch and time for CNN processing  
        frames = videos.view(b * t, c, h, w)  
        features = self.cnn(frames)         # (b*t, 64, 1, 1)  
        features = features.view(b * t, 64)  
        features = self.fc(features)        # (b*t, cnn_out_dim)  
        # Restore batch and time dimensions  
        features = features.view(b, t, -1)  # (b, t, cnn_out_dim)  
        # LSTM expects (batch, seq_len, feature)  
        lstm_out, _ = self.lstm(features)   # (b, t, hidden_dim)  
        # Use the final hidden state of LSTM for classification  
        final = lstm_out[:, -1, :]          # (b, hidden_dim)  
        logits = self.classifier(final)     # (b, num_classes)  
        return logits  

def main():  
    # Test the CNNLSTM model with dummy data  
    model = CNNLSTM(num_classes=10)  
    dummy_videos = torch.randn(4, 16, 3, 64, 64)  # Batch of 4, each with 16 frames  
    outputs = model(dummy_videos)                 # (4, 10)  
    print(outputs.shape)                          # Should print: torch.Size([4, 10])

if __name__ == "__main__":  
    main()