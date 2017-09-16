package cn.allene.yun.controller;

public class TestController {
	
	public static void main(String[] args) {
		int a = 1;
		int b = -1;
		int n = 10;
		int count = 0;
		if(a < b){
			for(int i = b; i < n; i++){
				if(i %(a * b) == 0){
					count++;
				}
			}
		}else{
			for(int i = a; i < n; i++){
				if(i %(a * b) == 0){
					count++;
				}
			}
		}
		System.out.println(count);
	}
}
