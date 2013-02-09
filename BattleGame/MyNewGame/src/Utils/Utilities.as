package Utils 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class Utilities 
	{
		
		static public function degreesToRadians(degrees:Number):Number 
		{
			return degrees * (Math.PI / 180);
		}
		static public function radiansToDegrees(radians:Number):Number 
		{
			return radians * (180 / Math.PI);
		}
		/**
		 * returns angle in degrees of object at x1, y1 to rotate towards point x2, y2
		 * @param	x1 
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return angle of rotation in degrees
		 */
		static public function rotateTowards(x1:Number, y1:Number , x2:Number , y2:Number ):Number 
		{
			var dx:Number = x1 - x2;
			var dy:Number  = y1 - y2;
			var radianAngle:Number = Math.atan2(dy, dx);
			return radianAngle;
		}
		/**
		 * Will project a point along an angle. Returns a point whose x and y are the x and y offset of the point along an angle.
		 * This function can also be used to plot the points of a circle. In that case make distance equal to the radius of the circle, with the circle's center at 0,0.
		 * @param	angle
		 * @param	distance
		 * @return point xOffset, yOffset
		 */
		static public function projectPointAlongAngle(angle:Number, distance:Number):Point 
		{
			var p:Point = new Point();
			p.x = Math.cos(Utilities.degreesToRadians(angle)) * distance;
			p.y = Math.sin(Utilities.degreesToRadians(angle)) * distance;
			return p;
		}
		static public function distanceBetweenTwoPoints(x1:Number, y1:Number , x2:Number , y2:Number ):Number 
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var p1:Point = new Point(x1, y1);
			var p2:Point = new Point(x2, y2);
			return  Math.sqrt(dx * dx + dy * dy);
		}
		
		static public function intersection(ax1:Number, ay1:Number, ax2:Number, ay2:Number ,bx1:Number, by1:Number, bx2:Number, by2:Number):Boolean
		{
			var v1:Number;
			var v2:Number;
			var v3:Number;
			var v4:Number;
			
			v1 = (bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1);
			v2 = (bx2 - bx1) * (ay2 - by1) - (by2 - by1) * (ax2 - bx1);
			v3 = (ax2 - ax1) * (by1 - ay1) - (ay2 - ay1) * (bx1 - ax1);
			v4 = (ax2 - ax1) * (by2 - ay1) - (ay2 - ay1) * (bx2 - ax1);
			
			return ((v1 * v2 < 0) && (v3 * v4 < 0));
		}
		
		
		//---------------------------------------------------------------
		//Checks for intersection of Segment if as_seg is true.
		//Checks for intersection of Line if as_seg is false.
		//Return intersection of Segment AB and Segment EF as a Point
		//Return null if there is no intersection
		//---------------------------------------------------------------
		static public function lineIntersectLine(A:Point,B:Point,E:Point,F:Point,as_seg:Boolean = true):Point 
		{
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;
			
			a1= B.y-A.y;
			b1= A.x-B.x;
			c1= B.x*A.y - A.x*B.y;
			a2= F.y-E.y;
			b2= E.x-F.x;
			c2= F.x*E.y - E.x*F.y;
			
			var denom:Number=a1*b2 - a2*b1;
			if (denom == 0) {
				return null;
			}
			ip=new Point();
			ip.x=(b1*c2 - b2*c1)/denom;
			ip.y=(a2*c1 - a1*c2)/denom;
			
			//---------------------------------------------------
			//Do checks to see if intersection to endpoints
			//distance is longer than actual Segments.
			//Return null if it is with any.
			//---------------------------------------------------
			if(as_seg){
				if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
					return null;
				}
				if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
					return null;
				}
				
				if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
					return null;
				}
				if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
					return null;
				}
			}
			return ip;
		}
	}
	
}