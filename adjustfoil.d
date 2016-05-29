/+

***************************
Adjustfoil Ver.1.0.1
翼型データベースから引っ張ってきた座標データをXflr5で認識できる形に直すというただそれだけのためのアプリケーション．

製作者:cristappj
***************************

+/

import std.stdio,
	   std.file,
	   std.string,
	   std.conv;

void main(){
target: 
	write("\nFile open: ");
	auto filename = chomp(readln());	//define a file.

	if(!exists(filename)){		//check file name.
		writeln("Error: file can not be opend");
target2: 
		write("Continue? (y/n): ");
		string ans1;
		ans1 = chomp(readln());
		switch(ans1){
			case "y" : 
				goto target;
			case "n" : 
				return;
			default : 
				writeln("Error: unexpected input");
				goto target2;
		}
	}
{
	auto file = File(filename, "r");
	write("\nStart line (0 origin): ");
	int start = to!(int)(chomp(readln()));  //define the value start line.

	write("\nValue form: ");
	string form = chomp(readln());	//define the value form.
	string foilname = file.readln();	//get the foil name.

	for(int i = 0; i < start - 1; i++){
		file.byLine.popFront();     // empty lines remove.
	}

target3:
	write("\nSelect mode (o/f)\n -o ... adjust order\n -f ... adjust format\n\n: ");
	string ans2;
	ans2 = chomp(readln()); 
	float x = void, y = void;
	float[] x_od, y_od;
	switch(ans2){
		case "o" : // adjust order mode
			int count = 0,
				border,
				flag = 0;
			file.byLine.popFront();  
			while (file.readf(form, &x, &y)){
				if(x == 1 && flag == 0){
					border = count;
					flag = 1;
				}
				x_od ~= x;
				y_od ~= y;
				//file.byLine.popFront();     // 1 line remove.
				//wip , 1 line remove over ride. 1行飛ばしをオーバライド。wip
				
				count++;	
			}

			float num1, num2;
			for(int i = 0; i < (cast(float) border/2); i++){
				num1 = x_od[i];
				x_od[i] = x_od[border - i];
				x_od[border - i] = num1;

				num2 = y_od[i];
				y_od[i] = y_od[border - i];
				y_od[border - i] = num2;
			}
			break;
			
		case "f" : //adjust format mode
			while (file.readf(form, &x, &y)){
				x_od ~= x;
				y_od ~= y;
				file.byLine.popFront();     // 1 line remove.	
			}
			break;
		default :
			writeln("Error: unexpected input");
			goto target3;
	}
		write("\nNew file name: ");
		auto newfilename = chomp(readln());	//define a file.

		{
			auto file2 = File(newfilename, "w");
			file2.writef(foilname);
			int k = 0;
			for(k = 0; k < x_od.length; k++){
				file2.writef(" %5f\t%5f\n", x_od[k], y_od[k]);	
			}
			writeln("\n...done \n");
		}
		
	}

target4: 
	write("Continue? (y/n): ");
	string ans;
	ans = chomp(readln());
	switch(ans){
		case "y" : 
			goto target;
		case "n" : 
			return;
		default :
			writeln("Error: unexpected input");
			goto target4;
	}
}

