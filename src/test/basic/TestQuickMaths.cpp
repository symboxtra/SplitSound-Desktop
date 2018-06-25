#include <iostream>
#include <gtest/gtest.h>

#include "Test.h"
#include "RTPNetworking.h"

TEST(TestQuickMaths, basicMath_canAdd)
{
	int result = add(2, 2);
	
	EXPECT_EQ(4, result);

	//RTPNetworking* rtp = new RTPNetworking();
}

TEST(TestQuickMaths, basicMath_canSubtract)
{
	int result = subtract(4, 1);
	
	EXPECT_EQ(3, result);
}
