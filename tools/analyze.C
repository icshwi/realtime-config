//
//  Copyright (c) Jeong Han Lee
//
//  The program is free software: you can redistribute
//  it and/or modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation, either version 2 of the
//  License, or any newer version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along with
//  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
//
// Author  : Jeong Han Lee
// email   : jeonghan.lee@gmail.com
// Date    : Thursday, December  5 17:13:36 CET 2019


#include <iostream>
#include "TApplication.h"
#include "TRint.h"
#include "TROOT.h"
#include "TSystem.h"
#include "TGTextEntry.h"
#include "TGClient.h"
#include "TGButton.h"
#include "TGLabel.h"
#include "TGFrame.h"
#include "TGLayout.h"
#include "TGWindow.h"
#include "TGLabel.h"
#include "TString.h"
#include "TGTextEdit.h"
#include "TGComboBox.h"
#include "TGText.h" 
#include "TObjArray.h"
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TProfile.h"
#include "TRandom.h"
#include "TTree.h"


TCanvas           *fCanvas;

void saveRootFile(TString filename="1.csv")
{
  TFile hfile(Form("%s.root", filename.Data()),"RECREATE");
  auto *tree = new TTree("tree", "a tree");
  tree->ReadFile(filename, "PV/C:Time/D:Data/D");
  
  tree->Print();
  // Save all objects in this file
  hfile.Write();
  hfile.Close();
  return 0;
}

void plots(TString filename="1.csv.root") 
{
  gROOT -> Reset();
  gStyle->SetHistMinimumZero(kTRUE);
  gStyle->SetOptStat(111111);
  
  TString path = gSystem->Getenv("PWD");
  
  if (path.IsNull()) { 
    printf("$PWD is not defined, please define them first\n");
    return NULL;
  }

  path += "/"; //  just in case...
  path += filename;
  
  TFile afile(path);
  if (afile.IsZombie()) { 
      printf("Error opening file\n"); 
      return NULL;
  }
  TTree* event_tree = nullptr;
  afile.GetObject("tree",event_tree);
  event_tree->SetEstimate(-1);

  if(fCanvas) fCanvas->Close(); delete fCanvas; fCanvas=NULL;
  fCanvas = new TCanvas(filename.Data(), filename.Data(), 800, 800);
  fCanvas->Clear();
  fCanvas->Divide(1,2);
  fCanvas->cd(1);
  gPad->SetGridy();
  gPad->SetGridx();
  gPad->SetLogy();
  event_tree->Draw("Data");

  TH1F *hist = (TH1F*)gPad->GetPrimitive("htemp");
  hist->SetTitle(Form("MCU Thread Latency Max Histogram at %s", filename.Data()));
  hist->GetXaxis()->SetTitle("Latency Max (nsec)");
  hist->GetXaxis()->CenterTitle();
  hist->GetYaxis()->SetTitle("counts");
  hist->GetYaxis()->CenterTitle();
  hist->Draw();   
  gPad->Update();

  fCanvas->cd(2);
  gPad->SetGridy();
  gPad->SetGridx();
  event_tree->Draw("Data:Time");
  TGraph *graph = (TGraph*)gPad->GetPrimitive("Graph");
  TH2D   *htemp = (TH2D*)gPad->GetPrimitive("htemp");
  // graph->SetLineColor(kRed);
  graph->SetLineWidth(1);
  //  htemp->SetTitle(Form("MCU Thread Latency Max Time Series at %s", filename.Data()));
  htemp->GetXaxis()->SetTitle("Time (sec)");
  htemp->GetYaxis()->SetTitle("Latency Max (nsec)");
  graph->Draw("LINE");



  fCanvas-> Modified();
  fCanvas-> Update();

  TImage *img = TImage::Create();
  img->FromPad(fCanvas);
  img->WriteImage(Form("%s_threadlatency.png", filename.Data()));
}





void plotHist(TString filename="1.csv.root") 
{
  gROOT -> Reset();
  gStyle->SetHistMinimumZero(kTRUE);
  gStyle->SetOptStat(111111);
  
  TString path = gSystem->Getenv("PWD");
  
  if (path.IsNull()) { 
    printf("$PWD is not defined, please define them first\n");
    return NULL;
  }

  path += "/"; //  just in case...
  path += filename;
  
  TFile afile(path);
  if (afile.IsZombie()) { 
      printf("Error opening file\n"); 
      return NULL;
  }
  TTree* event_tree = nullptr;
  afile.GetObject("tree",event_tree);
  event_tree->SetEstimate(-1);

  if(fCanvas) fCanvas->Close(); delete fCanvas; fCanvas=NULL;
  fCanvas = new TCanvas(filename.Data(), filename.Data(), 640, 480);
  fCanvas->Clear();
  // fCanvas->cd(1);
  gPad->SetGridy();
  gPad->SetLogy();
  event_tree->Draw("Data");

  TH1F *hist = (TH1F*)gPad->GetPrimitive("htemp");
  hist->SetTitle(Form("MCU Thread Latency Max Histogram at %s", filename.Data()));
  hist->GetXaxis()->SetTitle("Latency Max (nsec)");
  hist->GetXaxis()->CenterTitle();
  hist->GetYaxis()->SetTitle("counts");
  hist->GetYaxis()->CenterTitle();
  hist->Draw();   
  gPad->Update();

  fCanvas-> Modified();
  fCanvas-> Update();

    

  // TImage *img = TImage::Create();
  // img->FromPad(fCanvas);
  // img->WriteImage(Form("%s_threadlatency.png", filename.Data()));

}


void plotTSGraph(TString filename="1.csv.root") 
{
  gROOT -> Reset();
  //  gStyle->SetHistMinimumZero(kTRUE);
  
  TString path = gSystem->Getenv("PWD");
  
  if (path.IsNull()) { 
    printf("$PWD is not defined, please define them first\n");
    return NULL;
  }

  path += "/"; //  just in case...
  path += filename;
  
  TFile afile(path);
  if (afile.IsZombie()) { 
      printf("Error opening file\n"); 
      return NULL;
  }
  TTree* event_tree = nullptr;
  afile.GetObject("tree",event_tree);
  event_tree->SetEstimate(-1);

  if(fCanvas) fCanvas->Close(); delete fCanvas; fCanvas=NULL;

  fCanvas = new TCanvas(filename.Data(), filename.Data(), 640, 480);
  fCanvas->Clear();

  event_tree->Draw("Data:Time");
  TGraph *graph = (TGraph*)gPad->GetPrimitive("Graph");
  TH2D   *htemp = (TH2D*)gPad->GetPrimitive("htemp");
  graph->SetLineColor(kRed);
  graph->SetLineWidth(1);
  //  htemp->SetTitle(Form("MCU Thread Latency Max Time Series at %s", filename.Data()));
  htemp->GetXaxis()->SetTitle("Time (sec)");
  htemp->GetYaxis()->SetTitle("Latency Max (nsec)");
  graph->Draw("LINE");


  gPad->Update();

  fCanvas-> Modified();
  fCanvas-> Update();
}

