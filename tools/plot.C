

//plot(TString filename)
{

  auto *event_tree = new TTree("event_tree", "a tree");
  
  event_tree->ReadFile("1.csv", "PV/C:Date/C:Data/F");
  //  c1.Clear();
  //  c1.Divide(2,1);
  //  Int_t i=0;
   event_tree->Draw("Data");
   //   gPad->Update();
   //   c1.Update();
   //   return;


}
