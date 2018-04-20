#include <iostream>
#include <gtest/gtest.h>

#include "Test.h"

TEST(TestQuickMaths, basicMath_canAdd)
{
	int result = add(2, 2);
	
	EXPECT_EQ(4, result);
}

TEST(TestQuickMaths, basicMath_canSubtract)
{
	int result = subtract(4, 1);
	
	EXPECT_EQ(3, result);
}