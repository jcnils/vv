/*=========================================================================
  Program:   vv                     http://www.creatis.insa-lyon.fr/rio/vv

  Authors belong to: 
  - University of LYON              http://www.universite-lyon.fr/
  - Léon Bérard cancer center       http://oncora1.lyon.fnclcc.fr
  - CREATIS CNRS laboratory         http://www.creatis.insa-lyon.fr

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.  See the copyright notices for more information.

  It is distributed under dual licence

  - BSD        See included LICENSE.txt file
  - CeCILL-B   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.html
======================================================================-====*/
#ifndef VVIMAGECONTOUR_H
#define VVIMAGECONTOUR_H

#include "clitkCommon.h"
#include "vvSlicer.h"

class vtkImageClip;
class vtkMarchingSquares;
class vtkActor;
class vvImage;

//------------------------------------------------------------------------------
class vvImageContour
{
  //  Q_OBJECT
 public:
  vvImageContour();
  ~vvImageContour();

  void setSlicer(vvSlicer * slicer);
  void update(double value);
  void hideActors();
  void showActors();
  void setColor(double r, double g, double b);
  void setImage(vvImage::Pointer image);
  void setPreserveMemoryModeEnabled(bool b);

 protected:
  vvSlicer * mSlicer;
  int mSlice;
  int mTSlice;
  double mValue;
  int mPreviousTSlice;
  double mPreviousValue;
  bool mHiddenImageIsUsed;
  vvImage::Pointer mHiddenImage;
  bool mDisplayModeIsPreserveMemory;

  // For preserveMemory mode
  std::vector<vtkImageClip*> mClipperList;
  std::vector<vtkMarchingSquares*> mSquaresList;
  std::vector<vtkActor*> mSquaresActorList;

  // For fast cache mode
  int mPreviousSlice;
  int mPreviousOrientation;
  std::vector<std::vector<vtkActor*> > mListOfCachedContourActors;

  // Functions
  void initializeCacheMode();
  void updateWithPreserveMemoryMode();
  void updateWithFastCacheMode();
  void createNewActor(vtkActor ** actor, 
		      vtkMarchingSquares ** squares, 
		      vtkImageClip ** clipper, int numImage);
  void updateActor(vtkActor * actor, 
		   vtkMarchingSquares * squares,
		   vtkImageClip * clipper, 
		   int threshold, int orientation, int slice);
  void createActor(int orientation, int slice);
  int computeCurrentOrientation();
  
}; // end class vvImageContour
//------------------------------------------------------------------------------

#endif

